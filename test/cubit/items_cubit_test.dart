import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';

class MockItemsLocalDataSource extends Mock implements ItemsLocalDataSource {}

class FakeMantiItem extends Fake implements MantiItem {}

void main() {
  late MockItemsLocalDataSource mockLocal;

  final item1 = MantiItem(
    idLocal: 'item1',
    name: 'Car',
    category: MantiCategory.vehicle,
    iconName: 'car',
    colorValue: 0xFF0000FF,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
  );

  final item2 = MantiItem(
    idLocal: 'item2',
    name: 'Laptop',
    category: MantiCategory.tech,
    iconName: 'laptop',
    colorValue: 0xFF00FF00,
    createdAt: DateTime(2025, 2, 1),
    updatedAt: DateTime(2025, 2, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeMantiItem());
  });

  setUp(() {
    mockLocal = MockItemsLocalDataSource();
    when(() => mockLocal.init()).thenAnswer((_) async {});
    when(() => mockLocal.watchAll()).thenAnswer((_) => const Stream.empty());
  });

  group('initialization', () {
    test('starts with loading state', () {
      final cubit = ItemsCubit(mockLocal);
      expect(cubit.state.isLoading, isTrue);
      expect(cubit.state.items, isEmpty);
    });

    test('emits loaded items when stream emits', () async {
      final controller = StreamController<List<MantiItem>>();
      when(() => mockLocal.watchAll()).thenAnswer((_) => controller.stream);

      final cubit = ItemsCubit(mockLocal);
      controller.add([item1, item2]);
      await Future.delayed(Duration.zero);

      expect(cubit.state.items, [item1, item2]);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNull);

      await controller.close();
    });

    test('updates state on stream re-emission', () async {
      final controller = StreamController<List<MantiItem>>();
      when(() => mockLocal.watchAll()).thenAnswer((_) => controller.stream);

      final cubit = ItemsCubit(mockLocal);
      controller.add([item1]);
      await Future.delayed(Duration.zero);
      expect(cubit.state.items, [item1]);

      controller.add([item1, item2]);
      await Future.delayed(Duration.zero);
      expect(cubit.state.items, [item1, item2]);

      await controller.close();
    });

    test('emits error state when stream errors', () async {
      final controller = StreamController<List<MantiItem>>();
      when(() => mockLocal.watchAll()).thenAnswer((_) => controller.stream);

      final cubit = ItemsCubit(mockLocal);
      controller.addError(Exception('DB failure'));
      await Future.delayed(Duration.zero);

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, contains('DB failure'));

      await controller.close();
    });

    test('calls init on the data source', () async {
      ItemsCubit(mockLocal);
      await Future.delayed(Duration.zero);
      verify(() => mockLocal.init()).called(1);
    });
  });

  group('addItem', () {
    test('calls upsert with the item', () async {
      when(() => mockLocal.upsert(any())).thenAnswer((_) async {});

      final cubit = ItemsCubit(mockLocal);
      await cubit.addItem(item1);

      verify(() => mockLocal.upsert(item1)).called(1);
    });
  });

  group('updateItem', () {
    test('calls upsert with updated updatedAt timestamp', () async {
      when(() => mockLocal.upsert(any())).thenAnswer((_) async {});

      final cubit = ItemsCubit(mockLocal);
      await cubit.updateItem(item1);

      final captured = verify(() => mockLocal.upsert(captureAny())).captured;
      final saved = captured.last as MantiItem;

      expect(saved.idLocal, item1.idLocal);
      expect(saved.name, item1.name);
      // updatedAt should be refreshed (after the original 2025-01-01).
      expect(saved.updatedAt.isAfter(item1.updatedAt), isTrue);
    });

    test('preserves all other fields when updating', () async {
      when(() => mockLocal.upsert(any())).thenAnswer((_) async {});

      final itemWithDates = MantiItem(
        idLocal: 'item3',
        name: 'Bike',
        category: MantiCategory.vehicle,
        iconName: 'bike',
        colorValue: 0xFFFF0000,
        lastMaintenance: DateTime(2025, 3, 1),
        nextMaintenance: DateTime(2025, 9, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      final cubit = ItemsCubit(mockLocal);
      await cubit.updateItem(itemWithDates);

      final captured = verify(() => mockLocal.upsert(captureAny())).captured;
      final saved = captured.last as MantiItem;

      expect(saved.lastMaintenance, itemWithDates.lastMaintenance);
      expect(saved.nextMaintenance, itemWithDates.nextMaintenance);
      expect(saved.category, MantiCategory.vehicle);
    });
  });

  group('deleteItem', () {
    test('calls deleteByIdLocal with the correct id', () async {
      when(() => mockLocal.deleteByIdLocal(any())).thenAnswer((_) async {});

      final cubit = ItemsCubit(mockLocal);
      await cubit.deleteItem('item1');

      verify(() => mockLocal.deleteByIdLocal('item1')).called(1);
    });
  });

  group('deleteAll', () {
    test('calls local deleteAll', () async {
      when(() => mockLocal.deleteAll()).thenAnswer((_) async {});

      final cubit = ItemsCubit(mockLocal);
      await cubit.deleteAll();

      verify(() => mockLocal.deleteAll()).called(1);
    });
  });
}
