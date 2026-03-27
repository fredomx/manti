import 'package:flutter_test/flutter_test.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';

MaintenanceLog _log({
  String id = 'log1',
  String itemId = 'item1',
  DateTime? date,
  String? title,
  int? frequencyDays,
  double? cost,
  double? mileage,
  String? notes,
}) =>
    MaintenanceLog(
      idLocal: id,
      itemId: itemId,
      date: date ?? DateTime(2025, 6, 1),
      title: title,
      notes: notes,
      mileage: mileage,
      cost: cost,
      frequencyDays: frequencyDays,
      createdAt: DateTime(2025, 1, 1),
    );

void main() {
  group('MaintenanceLog.copyWith', () {
    test('no-op produces equal log', () {
      final log = _log();
      expect(log.copyWith(), equals(log));
    });

    test('updates date', () {
      final newDate = DateTime(2025, 12, 31);
      final copy = _log().copyWith(date: newDate);
      expect(copy.date, newDate);
    });

    test('updates title', () {
      final copy = _log().copyWith(title: 'Oil change');
      expect(copy.title, 'Oil change');
    });

    test('updates frequencyDays', () {
      final copy = _log().copyWith(frequencyDays: 90);
      expect(copy.frequencyDays, 90);
    });

    test('preserves frequencyDays when not passed', () {
      final log = _log(frequencyDays: 30);
      final copy = log.copyWith(title: 'Changed');
      expect(copy.frequencyDays, 30);
    });

    test('updates cost and mileage', () {
      final copy = _log().copyWith(cost: 150.0, mileage: 45000.0);
      expect(copy.cost, 150.0);
      expect(copy.mileage, 45000.0);
    });
  });

  group('MaintenanceLog equality', () {
    test('identical logs are equal', () {
      final a = _log();
      final b = _log();
      expect(a, equals(b));
    });

    test('logs with different ids are not equal', () {
      expect(_log(id: 'log1'), isNot(equals(_log(id: 'log2'))));
    });

    test('logs with different dates are not equal', () {
      expect(
        _log(date: DateTime(2025, 1, 1)),
        isNot(equals(_log(date: DateTime(2025, 6, 1)))),
      );
    });

    test('logs with different frequencyDays are not equal', () {
      expect(_log(frequencyDays: 30), isNot(equals(_log(frequencyDays: 90))));
    });

    test('log with frequency != log without frequency', () {
      expect(_log(frequencyDays: 30), isNot(equals(_log())));
    });
  });

  group('MaintenanceLog fields', () {
    test('all optional fields default to null', () {
      final log = _log();
      expect(log.title, isNull);
      expect(log.notes, isNull);
      expect(log.mileage, isNull);
      expect(log.cost, isNull);
      expect(log.frequencyDays, isNull);
    });

    test('all optional fields stored correctly', () {
      final log = _log(
        title: 'Oil change',
        notes: 'Used synthetic oil',
        mileage: 45000.5,
        cost: 120.0,
        frequencyDays: 180,
      );
      expect(log.title, 'Oil change');
      expect(log.notes, 'Used synthetic oil');
      expect(log.mileage, 45000.5);
      expect(log.cost, 120.0);
      expect(log.frequencyDays, 180);
    });
  });
}
