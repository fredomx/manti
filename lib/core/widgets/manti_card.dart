import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manti/core/utils/date_utils.dart';
import 'package:manti/core/widgets/manti_icons.dart';
import 'package:manti/core/ui/dialogs/confirm_delete_dialog.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

class MantiCard extends StatelessWidget {
  final MantiItem item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MantiCard({
    super.key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color get _statusColor {
    if (item.nextMaintenance == null) {
      // No log-based schedule set yet — neutral
      return Colors.white.withValues(alpha: 0.4);
    }
    switch (item.status) {
      case MaintenanceStatus.onTime:
        return Colors.greenAccent;
      case MaintenanceStatus.warning:
        return Colors.amberAccent;
      case MaintenanceStatus.overdue:
        return Colors.redAccent;
    }
  }

  void _showActions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(item.name),
        actions: [
          if (onEdit != null)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                onEdit!();
              },
              child: const Text('Editar'),
            ),
          if (onDelete != null)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(context);
                final confirmed = await showDeleteConfirmDialog(
                  context,
                  title: item.name,
                );
                if (confirmed) onDelete!();
              },
              child: const Text('Eliminar'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActions(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(item.colorValue),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        item.categoryLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  iconForName(item.iconName),
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),
            Text(
              item.name.trim(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            // Last maintenance date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 10,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _lastMaintenanceText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Next / status
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    _nextText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  String _lastMaintenanceText() {
    final last = item.lastMaintenance;
    if (last == null) return 'Sin registros aún';
    return 'Último ${fmtDateShort(last)}';
  }

  String _nextText() {
    final next = item.nextMaintenance;
    if (next == null) return 'Sin servicios programados';
    final diff = next.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Atrasado ${diff.abs()}d';
    if (diff == 0) return 'Servicio hoy';
    if (diff == 1) return 'Servicio mañana';
    return 'Próximo en ${diff}d';
  }

}

