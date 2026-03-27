import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manti/core/ui/app_scaffold.dart';
import 'package:manti/core/ui/dialogs/confirm_delete_dialog.dart';
import 'package:manti/core/utils/date_utils.dart';
import 'package:manti/core/widgets/manti_icons.dart';
import 'package:manti/core/ui/buttons/manti_glass_fab.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/data/local/logs_local_data_source.dart';
import 'package:manti/features/manti/presentation/cubit/logs_cubit.dart';
import 'package:manti/features/manti/presentation/cubit/logs_state.dart';
import 'package:manti/features/manti/presentation/pages/maintenance_log/new_log_sheet.dart';

class MaintenanceLogScreen extends StatelessWidget {
  final MantiItem item;

  const MaintenanceLogScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final isar = context.read<Isar>();
        final logsLocal = LogsLocalDataSource(isar);
        final itemsLocal = ItemsLocalDataSource(isar);
        return LogsCubit(logsLocal, itemsLocal, itemId: item.idLocal);
      },
      child: _MaintenanceLogView(item: item),
    );
  }
}

class _MaintenanceLogView extends StatelessWidget {
  final MantiItem item;

  const _MaintenanceLogView({required this.item});

  // Returns upcoming services (explicit future reminders + calculated recurring)
  // and filtered history (past-only logs). Logs must be sorted desc by date.
  static (List<_UpcomingService>, List<MaintenanceLog>) _splitLogs(
      List<MaintenanceLog> logs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcoming = <_UpcomingService>[];
    final history = <MaintenanceLog>[];
    final latestPastRecurring = <String, MaintenanceLog>{};

    for (final log in logs) {
      final logDay = DateTime(log.date.year, log.date.month, log.date.day);
      if (logDay.isAfter(today)) {
        // Future log → explicit reminder in upcoming section
        final displayTitle =
            log.title?.trim().isNotEmpty == true ? log.title!.trim() : 'Recordatorio';
        upcoming.add(_UpcomingService(
          title: displayTitle,
          nextDate: log.date,
          frequencyDays: log.frequencyDays,
          sourceLogId: log.idLocal,
          isExplicitReminder: true,
          daysUntil: log.date.difference(now).inDays,
        ));
      } else {
        // Past log → history; also seed recurring calculation
        history.add(log);
        if (log.frequencyDays != null) {
          final key = log.title?.trim().toLowerCase() ?? '';
          latestPastRecurring.putIfAbsent(key, () => log);
        }
      }
    }

    // Calculated recurring services from past logs
    for (final log in latestPastRecurring.values) {
      final displayTitle =
          log.title?.trim().isNotEmpty == true ? log.title!.trim() : 'Mantenimiento';
      final nextDate = log.date.add(Duration(days: log.frequencyDays!));
      upcoming.add(_UpcomingService(
        title: displayTitle,
        nextDate: nextDate,
        frequencyDays: log.frequencyDays,
        sourceLogId: log.idLocal,
        isExplicitReminder: false,
        daysUntil: nextDate.difference(now).inDays,
      ));
    }

    upcoming.sort((a, b) => a.nextDate.compareTo(b.nextDate));
    return (upcoming, history);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingButton: MantiGlassFab(
        icon: Icons.add_rounded,
        label: 'Nuevo registro',
        onPressed: () => showNewLogSheet(context, item.category),
      ),
      body: BlocBuilder<LogsCubit, LogsState>(
        builder: (context, state) {
          final (upcoming, historyLogs) = _splitLogs(state.logs);
          final lastMaintenance =
              historyLogs.isNotEmpty ? historyLogs.first.date : null;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ItemHero(
                  item: item,
                  logCount: state.logs.length,
                  lastMaintenance: lastMaintenance,
                  upcoming: upcoming,
                ),
              ),
              if (state.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.black45),
                    ),
                  ),
                )
              else if (state.logs.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyLogs(),
                )
              else ...[
                // ── Upcoming services & reminders ─────────────────────────
                if (upcoming.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Próximos',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.35),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    sliver: SliverList.separated(
                      itemCount: upcoming.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final svc = upcoming[index];
                        return _UpcomingCard(
                          key: ValueKey(svc.sourceLogId),
                          service: svc,
                          onComplete: svc.isExplicitReminder
                              ? () => context
                                  .read<LogsCubit>()
                                  .completeExplicitReminder(svc.sourceLogId)
                              : () => context
                                  .read<LogsCubit>()
                                  .completeUpcomingService(svc.sourceLogId),
                          onRemove: svc.isExplicitReminder
                              ? () => context
                                  .read<LogsCubit>()
                                  .deleteLog(svc.sourceLogId)
                              : () => context
                                  .read<LogsCubit>()
                                  .removeServiceFrequency(svc.sourceLogId),
                        );
                      },
                    ),
                  ),
                ],

                // ── History ───────────────────────────────────────────────
                if (historyLogs.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Historial',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.35),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 160),
                    sliver: SliverList.separated(
                      itemCount: historyLogs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final log = historyLogs[index];
                        return _SwipeableLogCard(
                          key: ValueKey(log.idLocal),
                          log: log,
                          onEdit: () => showEditLogSheet(context, log, item.category),
                          onDelete: () =>
                              context.read<LogsCubit>().deleteLog(log.idLocal),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 160),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _fmtFrequency(int days) {
  if (days >= 730) return 'c/${days ~/ 365} años';
  if (days >= 365) return 'c/año';
  if (days >= 180) return 'c/6 meses';
  if (days >= 90) return 'c/3 meses';
  if (days >= 30) return 'c/mes';
  return 'c/${days}d';
}

// ── Upcoming service model ────────────────────────────────────────────────────

class _UpcomingService {
  final String title;
  final DateTime nextDate;
  final int? frequencyDays;
  final String sourceLogId;
  /// True when the user explicitly set a future date; false when calculated
  /// from a past log's recurrence.
  final bool isExplicitReminder;
  /// Computed once at construction from the caller's DateTime.now() snapshot
  /// so every card in the list shares the same reference instant.
  final int daysUntil;

  const _UpcomingService({
    required this.title,
    required this.nextDate,
    required this.sourceLogId,
    required this.isExplicitReminder,
    required this.daysUntil,
    this.frequencyDays,
  });

  bool get isOverdue => daysUntil < 0;
  bool get isWarning => !isOverdue && daysUntil <= 30;
}

// ── Upcoming card ─────────────────────────────────────────────────────────────

class _UpcomingCard extends StatelessWidget {
  final _UpcomingService service;
  final Future<void> Function() onComplete;
  final VoidCallback onRemove;

  const _UpcomingCard({
    super.key,
    required this.service,
    required this.onComplete,
    required this.onRemove,
  });

  /// Returns the date of the next notification that will fire, or null if none.
  DateTime? get _nextNotifDate {
    final days = service.daysUntil;
    if (days <= 0) return null;
    if (days > 30) return service.nextDate.subtract(const Duration(days: 30));
    if (days > 7) return service.nextDate.subtract(const Duration(days: 7));
    return service.nextDate; // day-of notification
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusLabel;
    final Color statusBg;

    if (service.isOverdue) {
      statusColor = const Color(0xFFFF3B30);
      statusBg = const Color(0x1AFF3B30);
      statusLabel = 'Atrasado ${service.daysUntil.abs()}d';
    } else if (service.isWarning) {
      statusColor = const Color(0xFFFF9500);
      statusBg = const Color(0x1AFF9500);
      statusLabel = 'En ${service.daysUntil}d';
    } else {
      statusColor = const Color(0xFF34C759);
      statusBg = const Color(0x1A34C759);
      statusLabel = 'En ${service.daysUntil}d';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Dismissible(
        key: ValueKey('upcoming_${service.sourceLogId}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Complete: advance the schedule, snap card back
            await onComplete();
            return false;
          }
          // Remove frequency: confirm before dismissing
          final confirmed = await showDeleteConfirmDialog(
            context,
            title: service.title,
          );
          if (confirmed) onRemove();
          return confirmed;
        },
        background: _SwipeBackground(
          alignment: Alignment.centerLeft,
          color: const Color(0xFF34C759),
          icon: Icons.check_rounded,
          label: 'Completar',
        ),
        secondaryBackground: _SwipeBackground(
          alignment: Alignment.centerRight,
          color: Colors.redAccent,
          icon: Icons.delete_outline_rounded,
          label: 'Eliminar',
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fmtDateShort(service.nextDate),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Frequency badge (only if recurring)
                  if (service.frequencyDays != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _fmtFrequency(service.frequencyDays!),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              // Notification hint
              if (_nextNotifDate != null) ...[
                const SizedBox(height: 10),
                Divider(height: 1, thickness: 0.5, color: Colors.black.withValues(alpha: 0.07)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 12,
                      color: Colors.black.withValues(alpha: 0.28),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Aviso el ${fmtDateShort(_nextNotifDate!)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────

class _ItemHero extends StatelessWidget {
  final MantiItem item;
  final int logCount;
  final DateTime? lastMaintenance;
  final List<_UpcomingService> upcoming;

  const _ItemHero({
    required this.item,
    required this.logCount,
    required this.lastMaintenance,
    required this.upcoming,
  });

  // Status derives from the earliest upcoming service, not item.frequencyDays.
  _UpcomingService? get _nextService =>
      upcoming.isEmpty ? null : upcoming.first;

  Color get _statusColor {
    final svc = _nextService;
    if (svc == null) return Colors.greenAccent;
    if (svc.isOverdue) return Colors.redAccent;
    if (svc.isWarning) return Colors.amberAccent;
    return Colors.greenAccent;
  }

  String get _statusLabel {
    final svc = _nextService;
    if (svc == null) return 'Al día';
    if (svc.isOverdue) return 'Atrasado';
    if (svc.isWarning) return 'Próximo';
    return 'Al día';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(item.colorValue),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Icon + name + badges
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              iconForName(item.iconName),
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
                                  child: _HeroBadge(label: item.categoryLabel),
                                ),
                                const SizedBox(width: 8),
                                _HeroBadge(
                                  label: _statusLabel,
                                  dot: _statusColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _StatBadge(
                          icon: Icons.history_rounded,
                          label: lastMaintenance != null
                              ? 'Último ${fmtDateShort(lastMaintenance!)}'
                              : 'Sin registros',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatBadge(
                          icon: Icons.event_rounded,
                          label: _nextService != null
                              ? 'Próximo · ${fmtDateShort(_nextService!.nextDate)}'
                              : 'Sin próximos',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom gradient fade
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final Color? dot;

  const _HeroBadge({required this.label, this.dot});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dot != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration:
                      BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Swipeable log card ────────────────────────────────────────────────────────

class _SwipeableLogCard extends StatelessWidget {
  final MaintenanceLog log;
  final Future<void> Function() onEdit;
  final VoidCallback onDelete;

  const _SwipeableLogCard({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Dismissible(
        key: ValueKey(log.idLocal),
        direction: DismissDirection.horizontal,
        // swipe right → edit (snap back), swipe left → delete
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await onEdit();
            return false;
          }
          return showDeleteConfirmDialog(
            context,
            title: log.title?.isNotEmpty == true ? log.title! : 'Mantenimiento',
          );
        },
        onDismissed: (_) => onDelete(),
        background: _SwipeBackground(
          alignment: Alignment.centerLeft,
          color: const Color(0xFF0A84FF),
          icon: Icons.edit_rounded,
          label: 'Editar',
        ),
        secondaryBackground: _SwipeBackground(
          alignment: Alignment.centerRight,
          color: Colors.redAccent,
          icon: Icons.delete_outline_rounded,
          label: 'Eliminar',
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.title ?? 'Mantenimiento',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (log.cost != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '\$${log.cost!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fmtDateShort(log.date),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: Colors.black38),
                  ),
                  if (log.notes != null && log.notes!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      log.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (log.mileage != null || log.frequencyDays != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (log.mileage != null) ...[
                          Icon(
                            Icons.speed_rounded,
                            size: 13,
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${log.mileage!.toStringAsFixed(0)} km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                        if (log.mileage != null && log.frequencyDays != null)
                          const SizedBox(width: 12),
                        if (log.frequencyDays != null) ...[
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _fmtFrequency(log.frequencyDays!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Color color;
  final IconData icon;
  final String label;

  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isLeft
            ? [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ]
            : [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 20),
              ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyLogs extends StatelessWidget {
  const _EmptyLogs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sin registros aún',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Toca + para agregar un mantenimiento. Puedes elegir una fecha pasada o futura.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black45,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 24),

          _LogHint(
            icon: Icons.schedule_rounded,
            text: 'Asigna una frecuencia (ej. cada 3 meses) y Manti calculará cuándo toca el próximo.',
          ),
          const SizedBox(height: 10),
          _LogHint(
            icon: Icons.event_rounded,
            text: 'Las fechas futuras aparecen en la sección de próximos con los días que faltan.',
          ),
          const SizedBox(height: 10),
          _LogHint(
            icon: Icons.swap_horiz_rounded,
            text: 'Desliza cualquier entrada para editarla, completarla o eliminarla.',
          ),
        ],
      ),
    );
  }
}

class _LogHint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LogHint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black26),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black.withValues(alpha: 0.4),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
