import 'package:flutter_test/flutter_test.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

MantiItem _item({DateTime? next, DateTime? last, MantiCategory category = MantiCategory.vehicle}) =>
    MantiItem(
      idLocal: 'id1',
      name: 'Test Item',
      category: category,
      iconName: 'car',
      colorValue: 0xFF0000FF,
      lastMaintenance: last,
      nextMaintenance: next,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

void main() {
  group('MantiItem.status', () {
    test('onTime when nextMaintenance is null', () {
      expect(_item().status, MaintenanceStatus.onTime);
    });

    test('overdue when nextMaintenance is in the past', () {
      expect(
        _item(next: DateTime.now().subtract(const Duration(days: 1))).status,
        MaintenanceStatus.overdue,
      );
    });

    test('overdue when nextMaintenance was many days ago', () {
      expect(
        _item(next: DateTime.now().subtract(const Duration(days: 100))).status,
        MaintenanceStatus.overdue,
      );
    });

    test('warning when nextMaintenance is within 30 days', () {
      expect(
        _item(next: DateTime.now().add(const Duration(days: 15))).status,
        MaintenanceStatus.warning,
      );
    });

    test('warning when nextMaintenance is exactly 30 days out', () {
      // diff = 30 which satisfies diff <= 30
      expect(
        _item(next: DateTime.now().add(const Duration(days: 30))).status,
        MaintenanceStatus.warning,
      );
    });

    test('onTime when nextMaintenance is more than 30 days out', () {
      // Use 32 days so Duration.inDays (which truncates) reliably returns > 30
      // even with a few microseconds of test execution delay.
      expect(
        _item(next: DateTime.now().add(const Duration(days: 32))).status,
        MaintenanceStatus.onTime,
      );
    });

    test('onTime when nextMaintenance is far in the future', () {
      expect(
        _item(next: DateTime.now().add(const Duration(days: 365))).status,
        MaintenanceStatus.onTime,
      );
    });
  });

  group('MantiItem.categoryLabel', () {
    test('vehicle', () => expect(_item(category: MantiCategory.vehicle).categoryLabel, 'Vehículo'));
    test('tech', () => expect(_item(category: MantiCategory.tech).categoryLabel, 'Tech'));
    test('tool', () => expect(_item(category: MantiCategory.tool).categoryLabel, 'Herramienta'));
    test('home', () => expect(_item(category: MantiCategory.home).categoryLabel, 'Hogar'));
    test('other without customCategory', () => expect(_item(category: MantiCategory.other).categoryLabel, 'Otro'));

    test('other with customCategory returns custom text', () {
      final item = MantiItem(
        idLocal: 'id1',
        name: 'Test',
        category: MantiCategory.other,
        customCategory: 'Mi categoría',
        iconName: 'star',
        colorValue: 0xFF000000,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
      expect(item.categoryLabel, 'Mi categoría');
    });

    test('other with empty customCategory falls back to Otro', () {
      final item = MantiItem(
        idLocal: 'id1',
        name: 'Test',
        category: MantiCategory.other,
        customCategory: '',
        iconName: 'star',
        colorValue: 0xFF000000,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
      expect(item.categoryLabel, 'Otro');
    });
  });

  group('MantiItem.copyWith', () {
    test('no-op produces equal item', () {
      final item = _item();
      expect(item.copyWith(), equals(item));
    });

    test('updates name', () {
      final copy = _item().copyWith(name: 'New Name');
      expect(copy.name, 'New Name');
      expect(copy.idLocal, 'id1');
    });

    test('can clear lastMaintenance with explicit null', () {
      final item = _item(last: DateTime(2025, 1, 1));
      final copy = item.copyWith(lastMaintenance: null);
      expect(copy.lastMaintenance, isNull);
    });

    test('preserves lastMaintenance when not passed', () {
      final date = DateTime(2025, 1, 1);
      final item = _item(last: date);
      final copy = item.copyWith(name: 'Changed');
      expect(copy.lastMaintenance, date);
    });

    test('can clear nextMaintenance with explicit null', () {
      final item = _item(next: DateTime(2025, 12, 31));
      final copy = item.copyWith(nextMaintenance: null);
      expect(copy.nextMaintenance, isNull);
    });

    test('preserves nextMaintenance when not passed', () {
      final date = DateTime(2025, 12, 31);
      final item = _item(next: date);
      final copy = item.copyWith(name: 'Changed');
      expect(copy.nextMaintenance, date);
    });

    test('updates category', () {
      final copy = _item().copyWith(category: MantiCategory.tech);
      expect(copy.category, MantiCategory.tech);
    });
  });

  group('MantiItem equality', () {
    test('two identical items are equal', () {
      final a = _item();
      final b = _item();
      expect(a, equals(b));
    });

    test('items with different idLocal are not equal', () {
      final a = MantiItem(
        idLocal: 'id1',
        name: 'Item',
        category: MantiCategory.vehicle,
        iconName: 'car',
        colorValue: 0xFF000000,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
      final b = a.copyWith(idLocal: 'id2');
      expect(a, isNot(equals(b)));
    });

    test('items with different nextMaintenance are not equal', () {
      final a = _item(next: DateTime(2025, 6, 1));
      final b = _item(next: DateTime(2025, 7, 1));
      expect(a, isNot(equals(b)));
    });
  });
}
