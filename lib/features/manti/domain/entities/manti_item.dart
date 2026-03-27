import 'package:equatable/equatable.dart';


enum MantiCategory { tech, vehicle, tool, home, other }

enum MaintenanceStatus { onTime, warning, overdue }



// Sentinel used in copyWith to distinguish "not passed" from explicit null.
const _unset = Object();

class MantiItem extends Equatable {
  final String idLocal;
  final String? idRemote;
  final String name;
  final MantiCategory category;
  /// Only meaningful when category == MantiCategory.other.
  final String? customCategory;
  final String iconName;
  final int colorValue;
  final DateTime? lastMaintenance;
  final DateTime? nextMaintenance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MantiItem({
    required this.idLocal,
    this.idRemote,
    required this.name,
    required this.category,
    this.customCategory,
    required this.iconName,
    required this.colorValue,
    this.lastMaintenance,
    this.nextMaintenance,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the display label for this item's category.
  String get categoryLabel {
    if (category == MantiCategory.other &&
        customCategory != null &&
        customCategory!.isNotEmpty) {
      return customCategory!;
    }
    switch (category) {
      case MantiCategory.tech:
        return 'Tech';
      case MantiCategory.vehicle:
        return 'Vehículo';
      case MantiCategory.tool:
        return 'Herramienta';
      case MantiCategory.home:
        return 'Hogar';
      case MantiCategory.other:
        return 'Otro';
    }
  }

  MaintenanceStatus get status {
    if (nextMaintenance == null) return MaintenanceStatus.onTime;

    final now = DateTime.now();
    final diff = nextMaintenance!.difference(now).inDays;

    if (diff < 0) return MaintenanceStatus.overdue;
    if (diff <= 30) return MaintenanceStatus.warning;
    return MaintenanceStatus.onTime;
  }

  MantiItem copyWith({
    String? idLocal,
    String? idRemote,
    String? name,
    MantiCategory? category,
    Object? customCategory = _unset,
    String? iconName,
    int? colorValue,
    Object? lastMaintenance = _unset,
    Object? nextMaintenance = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MantiItem(
      idLocal: idLocal ?? this.idLocal,
      idRemote: idRemote ?? this.idRemote,
      name: name ?? this.name,
      category: category ?? this.category,
      customCategory: identical(customCategory, _unset)
          ? this.customCategory
          : customCategory as String?,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      lastMaintenance: identical(lastMaintenance, _unset)
          ? this.lastMaintenance
          : lastMaintenance as DateTime?,
      nextMaintenance: identical(nextMaintenance, _unset)
          ? this.nextMaintenance
          : nextMaintenance as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    idLocal,
    idRemote,
    name,
    category,
    customCategory,
    iconName,
    colorValue,
    lastMaintenance,
    nextMaintenance,
    createdAt,
    updatedAt,
  ];
}
