import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

class ProgressCard extends StatelessWidget {
  final List<MantiItem> items;

  const ProgressCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final onTimeCount =
        items.where((i) => i.status == MaintenanceStatus.onTime).length;
    final warningCount =
        items.where((i) => i.status == MaintenanceStatus.warning).length;
    final overdueCount =
        items.where((i) => i.status == MaintenanceStatus.overdue).length;
    final total = items.length;

    final String headline;
    if (total == 0) {
      headline = 'Sin artículos aún';
    } else if (overdueCount > 0) {
      headline =
          '$overdueCount atrasado${overdueCount > 1 ? 's' : ''} · atención requerida';
    } else if (warningCount > 0) {
      headline = '$warningCount próximo${warningCount > 1 ? 's' : ''} · casi es momento';
    } else {
      headline = 'Todo al día · sin pendientes';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Estado de tu flota',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                headline,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),

              // Segmented bar
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 8,
                  child: total == 0
                      ? Container(
                          color: Colors.black.withValues(alpha: 0.07),
                        )
                      : Row(
                          children: [
                            if (onTimeCount > 0)
                              Expanded(
                                flex: onTimeCount,
                                child: Container(
                                  color: const Color(0xFF34C759),
                                ),
                              ),
                            if (warningCount > 0)
                              Expanded(
                                flex: warningCount,
                                child: Container(
                                  color: const Color(0xFFFF9500),
                                ),
                              ),
                            if (overdueCount > 0)
                              Expanded(
                                flex: overdueCount,
                                child: Container(
                                  color: const Color(0xFFFF3B30),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Status chips row
              if (total == 0)
                Text(
                  'Agrega artículos para ver su estado',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black38,
                  ),
                )
              else
                Row(
                  children: [
                    if (onTimeCount > 0) ...[
                      _StatusChip(
                        count: onTimeCount,
                        label: 'al día',
                        color: const Color(0xFF34C759),
                        icon: Icons.check_circle_rounded,
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (warningCount > 0) ...[
                      _StatusChip(
                        count: warningCount,
                        label: 'pronto',
                        color: const Color(0xFFFF9500),
                        icon: Icons.access_time_rounded,
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (overdueCount > 0)
                      _StatusChip(
                        count: overdueCount,
                        label: 'atrasado${overdueCount > 1 ? 's' : ''}',
                        color: const Color(0xFFFF3B30),
                        icon: Icons.warning_rounded,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.count,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
