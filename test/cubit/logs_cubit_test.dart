import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/data/local/logs_local_data_source.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/presentation/cubit/logs_cubit.dart';

class MockLogsLocalDataSource extends Mock implements LogsLocalDataSource {}

class MockItemsLocalDataSource extends Mock implements ItemsLocalDataSource {}

// Fallback values required by mocktail when using any() with custom types.
class FakeMantiItem extends Fake implements MantiItem {}

class FakeMaintenanceLog extends Fake implements MaintenanceLog {}

/// A no-op platform implementation that satisfies MockPlatformInterfaceMixin
/// so PlatformInterface.verifyToken allows it as FlutterLocalNotificationsPlatform.instance.
/// resolvePlatformSpecificImplementation<IOS/Android>() returns null for this
/// type, making requestPermission() a safe no-op in tests.
class FakeFlutterLocalNotificationsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterLocalNotificationsPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogsLocalDataSource mockLogs;
  late MockItemsLocalDataSource mockItems;

  const itemId = 'item1';

  final baseItem = MantiItem(
    idLocal: itemId,
    name: 'Test Car',
    category: MantiCategory.vehicle,
    iconName: 'car',
    colorValue: 0xFF0000FF,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
  );

  MaintenanceLog makeLog({
    String id = 'log1',
    required DateTime date,
    String? title,
    int? frequencyDays,
    String? notes,
  }) =>
      MaintenanceLog(
        idLocal: id,
        itemId: itemId,
        date: date,
        title: title,
        notes: notes,
        frequencyDays: frequencyDays,
        createdAt: date,
      );

  setUpAll(() {
    registerFallbackValue(FakeMantiItem());
    registerFallbackValue(FakeMaintenanceLog());

    // Register a fake platform so FlutterLocalNotificationsPlatform.instance
    // is never uninitialized. resolvePlatformSpecificImplementation<iOS/Android>
    // returns null for this type, so requestPermission() becomes a no-op.
    FlutterLocalNotificationsPlatform.instance =
        FakeFlutterLocalNotificationsPlatform();

    // Silence any residual method-channel calls from the plugin.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (call) async => null,
    );
  });

  setUp(() {
    mockLogs = MockLogsLocalDataSource();
    mockItems = MockItemsLocalDataSource();

    // Default: watchByItem returns empty stream so _init() subscription is quiet.
    when(() => mockLogs.watchByItem(itemId))
        .thenAnswer((_) => const Stream.empty());

    // Default stubs for the delete-trigger pattern used in _refreshItemDates tests.
    when(() => mockLogs.deleteLog(any())).thenAnswer((_) async {});
    when(() => mockItems.upsert(any())).thenAnswer((_) async {});
  });

  /// Creates a cubit and waits for the async _init() to complete.
  Future<LogsCubit> buildCubit() async {
    final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
    await Future.delayed(Duration.zero);
    return cubit;
  }

  /// Triggers _refreshItemDates via deleteLog so we can assert on the upsert
  /// argument without going through the requestPermission() platform path.
  Future<MantiItem> triggerRefreshAndCapture({
    required LogsCubit cubit,
    required List<MaintenanceLog> logs,
  }) async {
    when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
    when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => logs);

    await cubit.deleteLog('trigger');

    final captured = verify(() => mockItems.upsert(captureAny())).captured;
    return captured.last as MantiItem;
  }

  // ─── _refreshItemDates: lastMaintenance ────────────────────────────────────

  group('lastMaintenance', () {
    test('is set to most recent past log date', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: yesterday)],
      );
      expect(updated.lastMaintenance?.day, yesterday.day);
      expect(updated.nextMaintenance, isNull);
    });

    test('uses the most recent when multiple past logs exist (sorted desc)', () async {
      final ago10 = DateTime.now().subtract(const Duration(days: 10));
      final ago30 = DateTime.now().subtract(const Duration(days: 30));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(id: 'a', date: ago10), makeLog(id: 'b', date: ago30)],
      );
      expect(updated.lastMaintenance?.day, ago10.day);
    });

    test('is null when only future logs exist', () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: tomorrow)],
      );
      expect(updated.lastMaintenance, isNull);
      expect(updated.nextMaintenance?.day, tomorrow.day);
    });

    test('is null when no logs exist', () async {
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(cubit: cubit, logs: []);
      expect(updated.lastMaintenance, isNull);
      expect(updated.nextMaintenance, isNull);
    });
  });

  // ─── _refreshItemDates: recurring nextMaintenance ──────────────────────────

  group('recurring nextMaintenance', () {
    test('is date + frequencyDays for a single recurring past log', () async {
      final daysAgo20 = DateTime.now().subtract(const Duration(days: 20));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: daysAgo20, title: 'Oil change', frequencyDays: 30)],
      );

      final expected = daysAgo20.add(const Duration(days: 30));
      expect(updated.nextMaintenance?.day, expected.day);
      expect(updated.nextMaintenance!.isAfter(DateTime.now()), isTrue);
    });

    test('uses the LATEST past log when multiple exist for same service title', () async {
      final daysAgo60 = DateTime.now().subtract(const Duration(days: 60));
      final daysAgo10 = DateTime.now().subtract(const Duration(days: 10));
      // Sorted desc (newer first) — putIfAbsent picks the first, i.e. latest.
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [
          makeLog(id: 'newer', date: daysAgo10, title: 'oil change', frequencyDays: 30),
          makeLog(id: 'older', date: daysAgo60, title: 'oil change', frequencyDays: 30),
        ],
      );

      // daysAgo10 + 30 = 20 days from now (not overdue).
      final expected = daysAgo10.add(const Duration(days: 30));
      expect(updated.nextMaintenance?.day, expected.day);
      expect(updated.nextMaintenance!.isAfter(DateTime.now()), isTrue);
    });

    test('picks the EARLIEST due date across multiple distinct services', () async {
      final daysAgo20 = DateTime.now().subtract(const Duration(days: 20));
      final daysAgo50 = DateTime.now().subtract(const Duration(days: 50));
      // Service A due in 10 days; Service B due in 40 days → A wins.
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [
          makeLog(id: 'a', date: daysAgo20, title: 'oil change', frequencyDays: 30),
          makeLog(id: 'b', date: daysAgo50, title: 'tire rotation', frequencyDays: 90),
        ],
      );

      final serviceADue = daysAgo20.add(const Duration(days: 30));
      expect(updated.nextMaintenance?.day, serviceADue.day);
    });

    test('future log with frequencyDays is EXCLUDED from recurring calc', () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      // This future log should NOT seed a recurring calculation.
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: tomorrow, title: 'oil change', frequencyDays: 30)],
      );

      // nextMaintenance = the explicit future date, not tomorrow + 30 days.
      expect(updated.nextMaintenance?.day, tomorrow.day);
      expect(updated.lastMaintenance, isNull);
    });

    test('overdue service: nextMaintenance is set to the (past) due date', () async {
      // Log 40 days ago with 30-day frequency → due 10 days AGO.
      // _refreshItemDates still records the due date so MantiItem.status → overdue.
      final daysAgo40 = DateTime.now().subtract(const Duration(days: 40));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: daysAgo40, title: 'Oil change', frequencyDays: 30)],
      );

      final expectedDue = daysAgo40.add(const Duration(days: 30));
      expect(updated.nextMaintenance?.day, expectedDue.day);
      // Due date is in the past → status == overdue.
      expect(updated.nextMaintenance!.isBefore(DateTime.now()), isTrue);
    });
  });

  // ─── _refreshItemDates: explicit future nextMaintenance ────────────────────

  group('explicit future nextMaintenance', () {
    test('equals the explicit future log date', () async {
      final inTwoWeeks = DateTime.now().add(const Duration(days: 14));
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [makeLog(date: inTwoWeeks, title: 'Checkup')],
      );

      expect(updated.nextMaintenance?.day, inTwoWeeks.day);
      expect(updated.lastMaintenance, isNull);
    });

    test('picks explicit future when it is sooner than recurring due date', () async {
      final daysAgo20 = DateTime.now().subtract(const Duration(days: 20));
      final inOneWeek = DateTime.now().add(const Duration(days: 7));
      // Recurring due in 10 days; explicit in 7 days → explicit wins.
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [
          makeLog(id: 'explicit', date: inOneWeek, title: 'Special'),
          makeLog(id: 'recur', date: daysAgo20, title: 'oil change', frequencyDays: 30),
        ],
      );

      expect(updated.nextMaintenance?.day, inOneWeek.day);
    });

    test('picks recurring when it is sooner than explicit future date', () async {
      final daysAgo5 = DateTime.now().subtract(const Duration(days: 5));
      final inOneMonth = DateTime.now().add(const Duration(days: 30));
      // Recurring due in 25 days; explicit in 30 days → recurring wins.
      final cubit = await buildCubit();
      final updated = await triggerRefreshAndCapture(
        cubit: cubit,
        logs: [
          makeLog(id: 'explicit', date: inOneMonth, title: 'Special'),
          makeLog(id: 'recur', date: daysAgo5, title: 'oil change', frequencyDays: 30),
        ],
      );

      final recurringDue = daysAgo5.add(const Duration(days: 30));
      expect(updated.nextMaintenance?.day, recurringDue.day);
    });
  });

  // ─── _refreshItemDates: edge cases ─────────────────────────────────────────

  group('_refreshItemDates edge cases', () {
    test('returns early without calling upsert when item not found', () async {
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => null);

      final cubit = await buildCubit();
      await cubit.deleteLog('log1');

      verifyNever(() => mockItems.upsert(any()));
    });
  });

  // ─── deleteLog ─────────────────────────────────────────────────────────────

  group('deleteLog', () {
    test('calls local deleteLog then refreshes item dates', () async {
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => []);

      final cubit = await buildCubit();
      await cubit.deleteLog('log1');

      verify(() => mockLogs.deleteLog('log1')).called(1);
      verify(() => mockItems.upsert(any())).called(1);
    });
  });

  // ─── updateLog ─────────────────────────────────────────────────────────────

  group('updateLog', () {
    test('calls local updateLog then refreshes item dates', () async {
      final log = makeLog(date: DateTime.now().subtract(const Duration(days: 1)));

      when(() => mockLogs.updateLog(any())).thenAnswer((_) async {});
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => [log]);

      final cubit = await buildCubit();
      await cubit.updateLog(log);

      verify(() => mockLogs.updateLog(log)).called(1);
      verify(() => mockItems.upsert(any())).called(1);
    });
  });

  // ─── addLog: past date, no frequency (safe path) ──────────────────────────

  group('addLog (past date, no frequency)', () {
    test('persists the log and triggers a date refresh', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      when(() => mockLogs.addLog(any())).thenAnswer((_) async {});
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId))
          .thenAnswer((_) async => [makeLog(date: yesterday)]);

      final cubit = await buildCubit();
      await cubit.addLog(date: yesterday, title: 'Oil change', cost: 80.0);

      final captured = verify(() => mockLogs.addLog(captureAny())).captured;
      final saved = captured.last as MaintenanceLog;

      expect(saved.date.day, yesterday.day);
      expect(saved.title, 'Oil change');
      expect(saved.cost, 80.0);
      expect(saved.itemId, itemId);
      verify(() => mockItems.upsert(any())).called(1);
    });
  });

  // ─── completeUpcomingService ────────────────────────────────────────────────

  group('completeUpcomingService', () {
    test('creates a new log dated today with same title and frequency', () async {
      final future = DateTime.now().add(const Duration(days: 14));
      final srcLog =
          makeLog(id: 'src', date: future, title: 'Oil change', frequencyDays: 90);

      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);
      when(() => mockLogs.addLog(any())).thenAnswer((_) async {});
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => [srcLog]);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      controller.add([srcLog]);
      await Future.delayed(Duration.zero);

      await cubit.completeUpcomingService('src');

      final captured = verify(() => mockLogs.addLog(captureAny())).captured;
      final newLog = captured.last as MaintenanceLog;

      expect(newLog.date.day, DateTime.now().day);
      expect(newLog.title, 'Oil change');
      expect(newLog.frequencyDays, 90);
      expect(newLog.itemId, itemId);

      await controller.close();
    });

    test('does nothing when source log is not in state', () async {
      final cubit = await buildCubit();
      await cubit.completeUpcomingService('nonexistent');

      verifyNever(() => mockLogs.addLog(any()));
    });

    test('does nothing when source log has no frequencyDays', () async {
      final future = DateTime.now().add(const Duration(days: 7));
      final srcLog = makeLog(id: 'src', date: future); // no frequency

      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      controller.add([srcLog]);
      await Future.delayed(Duration.zero);

      await cubit.completeUpcomingService('src');

      verifyNever(() => mockLogs.addLog(any()));
      await controller.close();
    });
  });

  // ─── completeExplicitReminder ──────────────────────────────────────────────

  group('completeExplicitReminder', () {
    test('updates log date to today, preserving all other fields', () async {
      final future = DateTime.now().add(const Duration(days: 7));
      final srcLog =
          makeLog(id: 'rem1', date: future, title: 'Checkup', notes: 'Remember oil');

      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);
      when(() => mockLogs.updateLog(any())).thenAnswer((_) async {});
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => [srcLog]);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      controller.add([srcLog]);
      await Future.delayed(Duration.zero);

      await cubit.completeExplicitReminder('rem1');

      final captured = verify(() => mockLogs.updateLog(captureAny())).captured;
      final updated = captured.last as MaintenanceLog;

      expect(updated.idLocal, 'rem1');
      expect(updated.date.day, DateTime.now().day);
      expect(updated.title, 'Checkup');
      expect(updated.notes, 'Remember oil');

      await controller.close();
    });

    test('does nothing when log not found', () async {
      final cubit = await buildCubit();
      await cubit.completeExplicitReminder('nonexistent');

      verifyNever(() => mockLogs.updateLog(any()));
    });
  });

  // ─── removeServiceFrequency ────────────────────────────────────────────────

  group('removeServiceFrequency', () {
    test('sets frequencyDays to null while preserving other fields', () async {
      final past = DateTime.now().subtract(const Duration(days: 30));
      final srcLog =
          makeLog(id: 'svc1', date: past, title: 'Oil change', frequencyDays: 90);

      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);
      when(() => mockLogs.updateLog(any())).thenAnswer((_) async {});
      when(() => mockItems.getByIdLocal(itemId)).thenAnswer((_) async => baseItem);
      when(() => mockLogs.getByItem(itemId)).thenAnswer((_) async => [srcLog]);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      controller.add([srcLog]);
      await Future.delayed(Duration.zero);

      await cubit.removeServiceFrequency('svc1');

      final captured = verify(() => mockLogs.updateLog(captureAny())).captured;
      final updated = captured.last as MaintenanceLog;

      expect(updated.idLocal, 'svc1');
      expect(updated.frequencyDays, isNull);
      expect(updated.title, 'Oil change');
      expect(updated.date.day, past.day);

      await controller.close();
    });

    test('does nothing when log not found', () async {
      final cubit = await buildCubit();
      await cubit.removeServiceFrequency('nonexistent');

      verifyNever(() => mockLogs.updateLog(any()));
    });
  });

  // ─── stream state ──────────────────────────────────────────────────────────

  group('LogsState stream updates', () {
    test('emits loaded logs when stream emits', () async {
      final log = makeLog(date: DateTime.now().subtract(const Duration(days: 1)));
      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);

      controller.add([log]);
      await Future.delayed(Duration.zero);

      expect(cubit.state.logs, [log]);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNull);

      await controller.close();
    });

    test('emits error state when stream errors', () async {
      final controller = StreamController<List<MaintenanceLog>>();
      when(() => mockLogs.watchByItem(itemId))
          .thenAnswer((_) => controller.stream);

      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      controller.addError(Exception('DB failure'));
      await Future.delayed(Duration.zero);

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, contains('DB failure'));

      await controller.close();
    });

    test('starts in loading state before stream emits', () {
      final cubit = LogsCubit(mockLogs, mockItems, itemId: itemId);
      expect(cubit.state.isLoading, isTrue);
    });
  });
}
