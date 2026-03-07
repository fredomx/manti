import 'dart:math';

import 'package:isar/isar.dart';
import 'package:manti/features/manti/data/local/app_config_isar.dart';
import 'package:manti/features/manti/data/local/manti_item_isar.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

class ItemsLocalDataSource {
  final Isar _isar;

  ItemsLocalDataSource(this._isar);

  Future<void> init() async {
    await _ensureSeededOnce();
  }

  Future<void> _ensureSeededOnce() async {
    final config = await _isar.appConfigIsars.get(1);
    if (config?.hasSeededMantiItems == true) return;

    final existingCount = await _isar.mantiItemIsars.count();
    if (existingCount > 0) {
      await _isar.writeTxn(() async {
        await _isar.appConfigIsars.put(
          AppConfigIsar()
            ..id = 1
            ..hasSeededMantiItems = true,
        );
      });
      return;
    }

    final seedItems = buildSeedItems();

    await _isar.writeTxn(() async {
      await _isar.mantiItemIsars.putAll(seedItems);
      await _isar.appConfigIsars.put(
        AppConfigIsar()
          ..id = 1
          ..hasSeededMantiItems = true,
      );
    });
  }

  List<MantiItemIsar> buildSeedItems() {
    final now = DateTime.now();
    final random = Random();

    return [
      MantiItemIsar()
        ..idLocal = DateTime.now().microsecondsSinceEpoch.toString()
        ..idRemote = null
        ..name = 'Servicio al auto'
        ..category = MantiCategory.vehicle
        ..iconName = 'car'
        ..colorValue = 0xFFFF8A65
        ..lastMaintenance = now.subtract(const Duration(days: 60))
        ..nextMaintenance = null
        ..createdAt = now
        ..updatedAt = now,

      MantiItemIsar()
        ..idLocal =
            (DateTime.now().microsecondsSinceEpoch + random.nextInt(999))
                .toString()
        ..idRemote = null
        ..name = 'Limpiar laptop'
        ..category = MantiCategory.tech
        ..iconName = 'tech'
        ..colorValue = 0xFF4DD0E1
        ..lastMaintenance = now.subtract(const Duration(days: 20))
        ..nextMaintenance = null
        ..createdAt = now
        ..updatedAt = now,

      MantiItemIsar()
        ..idLocal =
            (DateTime.now().microsecondsSinceEpoch + random.nextInt(9999))
                .toString()
        ..idRemote = null
        ..name = 'Afilado de herramienta'
        ..category = MantiCategory.tool
        ..iconName = 'tool'
        ..colorValue = 0xFFBA68C8
        ..lastMaintenance = now.subtract(const Duration(days: 100))
        ..nextMaintenance = null
        ..createdAt = now
        ..updatedAt = now,
    ];
  }

  Future<MantiItem?> getByIdLocal(String idLocal) async {
    final found = await _isar.mantiItemIsars
        .filter()
        .idLocalEqualTo(idLocal)
        .findFirst();
    return found?.toDomain();
  }

  Future<List<MantiItem>> getAll() async {
    final isarItems = await _isar.mantiItemIsars.where().findAll();
    return isarItems.map((e) => e.toDomain()).toList();
  }

  Stream<List<MantiItem>> watchAll() {
    return _isar.mantiItemIsars
        .where()
        .watch(fireImmediately: true)
        .map((isarList) => isarList.map((e) => e.toDomain()).toList());
  }

  Future<void> upsert(MantiItem item) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.mantiItemIsars
          .filter()
          .idLocalEqualTo(item.idLocal)
          .findFirst();

      final model = MantiItemIsar.fromDomain(item);

      if (existing != null) {
        model.id = existing.id;
      }

      await _isar.mantiItemIsars.put(model);
    });
  }

  Future<void> deleteByIdLocal(String idLocal) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.mantiItemIsars
          .filter()
          .idLocalEqualTo(idLocal)
          .findFirst();

      if (existing != null) {
        await _isar.mantiItemIsars.delete(existing.id);
      }
    });
  }

  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.mantiItemIsars.clear();
    });
  }
}
