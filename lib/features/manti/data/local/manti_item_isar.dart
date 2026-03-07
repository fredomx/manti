import 'package:isar/isar.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

part 'manti_item_isar.g.dart';

@collection
class MantiItemIsar {
  /// Internal Isar ID (auto-increment)
  Id id = Isar.autoIncrement;

  late String idLocal;
  String? idRemote;
  late String name;

  @enumerated
  late MantiCategory category;

  String? customCategory;
  late String iconName;
  late int colorValue;
  DateTime? lastMaintenance;
  DateTime? nextMaintenance;
  late DateTime createdAt;
  late DateTime updatedAt;

  MantiItem toDomain() {
    return MantiItem(
      idLocal: idLocal,
      idRemote: idRemote,
      name: name,
      category: category,
      customCategory: customCategory,
      iconName: iconName,
      colorValue: colorValue,
      lastMaintenance: lastMaintenance,
      nextMaintenance: nextMaintenance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static MantiItemIsar fromDomain(MantiItem item) {
    final model = MantiItemIsar()
      ..idLocal = item.idLocal
      ..idRemote = item.idRemote
      ..name = item.name
      ..category = item.category
      ..customCategory = item.customCategory
      ..iconName = item.iconName
      ..colorValue = item.colorValue
      ..lastMaintenance = item.lastMaintenance
      ..nextMaintenance = item.nextMaintenance
      ..createdAt = item.createdAt
      ..updatedAt = item.updatedAt;

    return model;
  }
}
