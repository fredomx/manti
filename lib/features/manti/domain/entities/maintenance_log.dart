import 'package:equatable/equatable.dart';

class MaintenanceLog extends Equatable {
  final String idLocal;
  final String itemId;
  final DateTime date;
  final String? title;
  final String? notes;
  final double? mileage;
  final double? cost;
  final int? frequencyDays;
  final DateTime createdAt;

  const MaintenanceLog({
    required this.idLocal,
    required this.itemId,
    required this.date,
    this.title,
    this.notes,
    this.mileage,
    this.cost,
    this.frequencyDays,
    required this.createdAt,
  });

  MaintenanceLog copyWith({
    String? idLocal,
    String? itemId,
    DateTime? date,
    String? title,
    String? notes,
    double? mileage,
    double? cost,
    int? frequencyDays,
    DateTime? createdAt,
  }) {
    return MaintenanceLog(
      idLocal: idLocal ?? this.idLocal,
      itemId: itemId ?? this.itemId,
      date: date ?? this.date,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      mileage: mileage ?? this.mileage,
      cost: cost ?? this.cost,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    idLocal,
    itemId,
    date,
    title,
    notes,
    mileage,
    cost,
    frequencyDays,
    createdAt,
  ];
}
