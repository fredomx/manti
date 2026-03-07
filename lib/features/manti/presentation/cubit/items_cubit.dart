import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/items_state.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final ItemsLocalDataSource _local;
  StreamSubscription<List<MantiItem>>? _subscription;

  ItemsCubit(this._local) : super(const ItemsState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    await _local.init();

    _subscription = _local.watchAll().listen(
      (items) {
        emit(
          state.copyWith(items: items, isLoading: false, errorMessage: null),
        );
      },
      onError: (error, _) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      },
    );
  }

  Future<void> addItem(MantiItem item) async {
    await _local.upsert(item);
  }

  Future<void> updateItem(MantiItem item) async {
    await _local.upsert(item.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteItem(String idLocal) async {
    await _local.deleteByIdLocal(idLocal);
  }

  Future<void> deleteAll() async {
    await _local.deleteAll();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }


}
