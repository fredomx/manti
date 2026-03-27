import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/services/notification_service.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:manti/features/manti/data/local/logs_local_data_source.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/presentation/cubit/logs_state.dart';

class LogsCubit extends Cubit<LogsState> {
  final LogsLocalDataSource _local;
  final ItemsLocalDataSource _items;
  final String itemId;

  StreamSubscription<List<MaintenanceLog>>? _subscription;

  LogsCubit(this._local, this._items, {required this.itemId})
      : super(const LogsState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    _subscription = _local.watchByItem(itemId).listen(
          (logs) {
        emit(
          state.copyWith(
            logs: logs,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onError: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> addLog({
    required DateTime date,
    String? title,
    String? notes,
    double? mileage,
    double? cost,
    int? frequencyDays,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final logDay = DateTime(date.year, date.month, date.day);
    if (frequencyDays != null || logDay.isAfter(today)) {
      await NotificationService.instance.requestPermission();
    }

    final log = MaintenanceLog(
      idLocal: now.microsecondsSinceEpoch.toString(),
      itemId: itemId,
      date: date,
      title: title,
      notes: notes,
      mileage: mileage,
      cost: cost,
      frequencyDays: frequencyDays,
      createdAt: now,
    );

    await _local.addLog(log);
    await _refreshItemDates();
  }

  Future<void> updateLog(MaintenanceLog log) async {
    await _local.updateLog(log);
    await _refreshItemDates();
  }

  Future<void> deleteLog(String idLocal) async {
    await _local.deleteLog(idLocal);
    await _refreshItemDates();
  }

  /// Marks an upcoming service as done today and schedules the next occurrence.
  /// Mirrors iOS Reminders: completing a recurring item advances it by its interval.
  Future<void> completeUpcomingService(String sourceLogId) async {
    final source = state.logs.where((l) => l.idLocal == sourceLogId).firstOrNull;
    if (source == null || source.frequencyDays == null) return;
    await addLog(
      date: DateTime.now(),
      title: source.title,
      frequencyDays: source.frequencyDays,
    );
  }

  /// Marks an explicit future-dated reminder as done today (moves it to history).
  Future<void> completeExplicitReminder(String logId) async {
    final source = state.logs.where((l) => l.idLocal == logId).firstOrNull;
    if (source == null) return;
    await updateLog(MaintenanceLog(
      idLocal: source.idLocal,
      itemId: source.itemId,
      date: DateTime.now(),
      title: source.title,
      notes: source.notes,
      mileage: source.mileage,
      cost: source.cost,
      frequencyDays: source.frequencyDays,
      createdAt: source.createdAt,
    ));
  }

  /// Removes the recurrence from a service without deleting the history entry.
  Future<void> removeServiceFrequency(String sourceLogId) async {
    final source = state.logs.where((l) => l.idLocal == sourceLogId).firstOrNull;
    if (source == null) return;
    await updateLog(MaintenanceLog(
      idLocal: source.idLocal,
      itemId: source.itemId,
      date: source.date,
      title: source.title,
      notes: source.notes,
      mileage: source.mileage,
      cost: source.cost,
      frequencyDays: null,
      createdAt: source.createdAt,
    ));
  }

  Future<void> _refreshItemDates() async {
    final item = await _items.getByIdLocal(itemId);
    if (item == null) return;

    // Single DB read — already sorted desc by date.
    final allLogs = await _local.getByItem(itemId);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Split past vs future logs (date-level comparison).
    final pastLogs = allLogs.where((l) {
      final d = DateTime(l.date.year, l.date.month, l.date.day);
      return !d.isAfter(today);
    }).toList();

    final futureLogs = allLogs.where((l) {
      final d = DateTime(l.date.year, l.date.month, l.date.day);
      return d.isAfter(today);
    }).toList();

    // lastMaintenance = most recent past log (allLogs sorted desc so pastLogs too).
    final latestDate = pastLogs.isNotEmpty ? pastLogs.first.date : null;

    // Recurring calculation from PAST logs only.
    final latestPerService = <String, MaintenanceLog>{};
    for (final log in pastLogs) {
      if (log.frequencyDays == null) continue;
      final key = log.title?.trim().toLowerCase() ?? '';
      latestPerService.putIfAbsent(key, () => log);
    }

    // nextMaintenance = earliest of: calculated recurring dates OR explicit future dates.
    final recurringDates =
        latestPerService.values.map((l) => l.date.add(Duration(days: l.frequencyDays!)));
    final explicitFutureDates = futureLogs.map((l) => l.date);
    final allUpcomingDates = [...recurringDates, ...explicitFutureDates];

    final nextMaintenance = allUpcomingDates.isEmpty
        ? null
        : allUpcomingDates.reduce((a, b) => a.isBefore(b) ? a : b);

    await _items.upsert(item.copyWith(
      lastMaintenance: latestDate,
      nextMaintenance: nextMaintenance,
      updatedAt: DateTime.now(),
    ));

    await NotificationService.instance.rescheduleForItem(
      itemId: itemId,
      itemName: item.name,
      logs: allLogs,
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
