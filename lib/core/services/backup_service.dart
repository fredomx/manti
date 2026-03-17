import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/data/local/logs_local_data_source.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  final ItemsLocalDataSource _items;
  final LogsLocalDataSource _logs;

  BackupService(this._items, this._logs);

  // ── Export ──────────────────────────────────────────────────────────────────

  Future<void> export() async {
    final items = await _items.getAll();
    final logs = await _logsForItems(items);

    final payload = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'items': items.map(_itemToJson).toList(),
      'logs': logs.map(_logToJson).toList(),
    };

    final dir = await getTemporaryDirectory();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final file = File('${dir.path}/manti_backup_$date.json');
    await file.writeAsString(jsonEncode(payload));

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Manti – copia de seguridad',
      ),
    );
  }

  // ── Restore ─────────────────────────────────────────────────────────────────

  /// Returns `true` if data was restored, `false` if the user cancelled.
  /// Throws on invalid file format.
  Future<bool> restore() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return false;

    final bytes = result.files.first.bytes;
    if (bytes == null) throw const FormatException('No se pudo leer el archivo.');

    final Map<String, dynamic> payload = jsonDecode(utf8.decode(bytes));

    if (payload['version'] != 1) {
      throw const FormatException('Formato de copia no reconocido.');
    }

    final items = (payload['items'] as List).map(_itemFromJson).toList();
    final logs = (payload['logs'] as List).map(_logFromJson).toList();

    // Replace everything atomically
    await _items.deleteAll();
    await _logs.deleteAll();
    await _items.insertAll(items);
    await _logs.insertAll(logs);

    return true;
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<List<MaintenanceLog>> _logsForItems(List<MantiItem> items) async {
    final result = <MaintenanceLog>[];
    for (final item in items) {
      result.addAll(await _logs.getByItem(item.idLocal));
    }
    return result;
  }

  Map<String, dynamic> _itemToJson(MantiItem i) => {
        'idLocal': i.idLocal,
        'idRemote': i.idRemote,
        'name': i.name,
        'category': i.category.name,
        'customCategory': i.customCategory,
        'iconName': i.iconName,
        'colorValue': i.colorValue,
        'lastMaintenance': i.lastMaintenance?.toIso8601String(),
        'nextMaintenance': i.nextMaintenance?.toIso8601String(),
        'createdAt': i.createdAt.toIso8601String(),
        'updatedAt': i.updatedAt.toIso8601String(),
      };

  MantiItem _itemFromJson(dynamic j) => MantiItem(
        idLocal: j['idLocal'] as String,
        idRemote: j['idRemote'] as String?,
        name: j['name'] as String,
        category: MantiCategory.values.byName(j['category'] as String),
        customCategory: j['customCategory'] as String?,
        iconName: j['iconName'] as String,
        colorValue: j['colorValue'] as int,
        lastMaintenance: j['lastMaintenance'] != null
            ? DateTime.parse(j['lastMaintenance'] as String)
            : null,
        nextMaintenance: j['nextMaintenance'] != null
            ? DateTime.parse(j['nextMaintenance'] as String)
            : null,
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );

  Map<String, dynamic> _logToJson(MaintenanceLog l) => {
        'idLocal': l.idLocal,
        'itemId': l.itemId,
        'date': l.date.toIso8601String(),
        'title': l.title,
        'notes': l.notes,
        'mileage': l.mileage,
        'cost': l.cost,
        'frequencyDays': l.frequencyDays,
        'createdAt': l.createdAt.toIso8601String(),
      };

  MaintenanceLog _logFromJson(dynamic j) => MaintenanceLog(
        idLocal: j['idLocal'] as String,
        itemId: j['itemId'] as String,
        date: DateTime.parse(j['date'] as String),
        title: j['title'] as String?,
        notes: j['notes'] as String?,
        mileage: (j['mileage'] as num?)?.toDouble(),
        cost: (j['cost'] as num?)?.toDouble(),
        frequencyDays: j['frequencyDays'] as int?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}
