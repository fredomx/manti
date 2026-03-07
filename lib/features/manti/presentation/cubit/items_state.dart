import 'package:equatable/equatable.dart';
import '../../domain/entities/manti_item.dart';

class ItemsState extends Equatable {
  final List<MantiItem> items;
  final bool isLoading;
  final String? errorMessage;

  const ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ItemsState copyWith({
    List<MantiItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}
