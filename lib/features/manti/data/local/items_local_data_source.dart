import 'package:isar/isar.dart';
import 'package:manti/features/manti/data/local/manti_item_isar.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

class ItemsLocalDataSource {
  final Isar _isar;

  ItemsLocalDataSource(this._isar);

  Future<void> init() async {}

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
    await _isar.writeTxn(() => _isar.mantiItemIsars.clear());
  }

  Future<void> insertAll(List<MantiItem> items) async {
    final models = items.map(MantiItemIsar.fromDomain).toList();
    await _isar.writeTxn(() => _isar.mantiItemIsars.putAll(models));
  }
}
