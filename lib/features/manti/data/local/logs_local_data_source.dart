import 'package:isar/isar.dart';
import 'package:manti/features/manti/data/local/maintenance_log_isar.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';

class LogsLocalDataSource {
  final Isar _isar;

  LogsLocalDataSource(this._isar);

  Future<List<MaintenanceLog>> getByItem(String itemId) async {
    final logs = await _isar.maintenanceLogIsars
        .filter()
        .itemIdEqualTo(itemId)
        .sortByDateDesc()
        .findAll();

    return logs.map((e) => e.toDomain()).toList();
  }

  Stream<List<MaintenanceLog>> watchByItem(String itemId) {
    return _isar.maintenanceLogIsars
        .filter()
        .itemIdEqualTo(itemId)
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((logs) => logs.map((e) => e.toDomain()).toList());
  }

  Future<void> addLog(MaintenanceLog log) async {
    final isarLog = MaintenanceLogIsar.fromDomain(log);

    await _isar.writeTxn(() async {
      await _isar.maintenanceLogIsars.put(isarLog);
    });
  }

  Future<void> updateLog(MaintenanceLog log) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.maintenanceLogIsars
          .filter()
          .idLocalEqualTo(log.idLocal)
          .findFirst();

      if (existing != null) {
        existing
          ..date = log.date
          ..title = log.title
          ..notes = log.notes
          ..mileage = log.mileage
          ..cost = log.cost
          ..frequencyDays = log.frequencyDays;
        await _isar.maintenanceLogIsars.put(existing);
      }
    });
  }

  Future<void> deleteLog(String idLocal) async {
    await _isar.writeTxn(() async {
      final log = await _isar.maintenanceLogIsars
          .filter()
          .idLocalEqualTo(idLocal)
          .findFirst();

      if (log != null) {
        await _isar.maintenanceLogIsars.delete(log.id);
      }
    });
  }

  Future<void> deleteAll() async {
    await _isar.writeTxn(() => _isar.maintenanceLogIsars.clear());
  }

  Future<void> insertAll(List<MaintenanceLog> logs) async {
    final models = logs.map(MaintenanceLogIsar.fromDomain).toList();
    await _isar.writeTxn(() => _isar.maintenanceLogIsars.putAll(models));
  }

}
