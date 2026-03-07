import 'package:isar/isar.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';

part 'maintenance_log_isar.g.dart';

@collection
class MaintenanceLogIsar {
  Id id = Isar.autoIncrement; // interno de Isar

  late String idLocal;
  late String itemId;
  late DateTime date;
  String? title;
  String? notes;
  double? mileage;
  double? cost;
  int? frequencyDays;
  late DateTime createdAt;

  MaintenanceLog toDomain() {
    return MaintenanceLog(
      idLocal: idLocal,
      itemId: itemId,
      date: date,
      title: title,
      notes: notes,
      mileage: mileage,
      cost: cost,
      frequencyDays: frequencyDays,
      createdAt: createdAt,
    );
  }

  static MaintenanceLogIsar fromDomain(MaintenanceLog log) {
    return MaintenanceLogIsar()
      ..idLocal = log.idLocal
      ..itemId = log.itemId
      ..date = log.date
      ..title = log.title
      ..notes = log.notes
      ..mileage = log.mileage
      ..cost = log.cost
      ..frequencyDays = log.frequencyDays
      ..createdAt = log.createdAt;
  }
}