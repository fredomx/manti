import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _permissionRequested = false;
  final Map<String, List<int>> _activeIds = {};

  static const _channelId = 'manti_reminders';
  static const _channelName = 'Recordatorios de mantenimiento';

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    _initialized = true;
  }

  Future<void> requestPermission() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  int _id(String itemId, String key, int slot) =>
      '${itemId}_${key}_$slot'.hashCode.abs() % 2000000000;

  tz.TZDateTime _at9am(DateTime date) =>
      tz.TZDateTime(tz.local, date.year, date.month, date.day, 9);

  static final _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Avisos cuando un servicio programado vence',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> _schedule(
    int id,
    String itemName,
    String body,
    tz.TZDateTime at,
    List<int> ids,
  ) async {
    if (!at.isAfter(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id,
      itemName,
      body,
      at,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    ids.add(id);
  }

  Future<void> rescheduleForItem({
    required String itemId,
    required String itemName,
    required List<MaintenanceLog> logs,
  }) async {
    if (!_initialized) return;

    for (final id in (_activeIds[itemId] ?? [])) {
      await _plugin.cancel(id);
    }
    _activeIds[itemId] = [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newIds = <int>[];

    // ── 1. Explicit future-dated reminders ────────────────────────────────────
    for (final log in logs) {
      final logDay = DateTime(log.date.year, log.date.month, log.date.day);
      if (!logDay.isAfter(today)) continue;

      final svc = log.title?.trim().isNotEmpty == true ? log.title!.trim() : 'Recordatorio';
      final key = 'reminder_${log.idLocal}';

      await _schedule(_id(itemId, key, 0), itemName, 'En 1 mes: $svc',    _at9am(log.date.subtract(const Duration(days: 30))), newIds);
      await _schedule(_id(itemId, key, 1), itemName, 'En 1 semana: $svc', _at9am(log.date.subtract(const Duration(days: 7))),  newIds);
      await _schedule(_id(itemId, key, 2), itemName, 'Hoy toca: $svc',    _at9am(log.date),                                   newIds);
    }

    // ── 2. Calculated recurring services (from past logs only) ────────────────
    final latestPerService = <String, MaintenanceLog>{};
    for (final log in logs) {
      if (log.frequencyDays == null) continue;
      final logDay = DateTime(log.date.year, log.date.month, log.date.day);
      if (logDay.isAfter(today)) continue; // future logs don't seed recurring calc
      latestPerService.putIfAbsent(log.title?.trim().toLowerCase() ?? '', () => log);
    }

    for (final entry in latestPerService.entries) {
      final log = entry.value;
      final due = log.date.add(Duration(days: log.frequencyDays!));
      if (!due.isAfter(now)) continue;

      final svc = log.title?.trim().isNotEmpty == true ? log.title!.trim() : 'Mantenimiento';

      await _schedule(_id(itemId, entry.key, 0), itemName, 'En 1 mes: $svc',    _at9am(due.subtract(const Duration(days: 30))), newIds);
      await _schedule(_id(itemId, entry.key, 1), itemName, 'En 1 semana: $svc', _at9am(due.subtract(const Duration(days: 7))),  newIds);
      await _schedule(_id(itemId, entry.key, 2), itemName, 'Hoy toca: $svc',    _at9am(due),                                   newIds);
    }

    _activeIds[itemId] = newIds;
  }

  Future<void> cancelForItem(String itemId) async {
    if (!_initialized) return;
    for (final id in (_activeIds[itemId] ?? [])) {
      await _plugin.cancel(id);
    }
    _activeIds.remove(itemId);
  }
}
