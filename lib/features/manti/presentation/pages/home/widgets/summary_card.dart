import 'dart:ui';

import 'package:flutter/material.dart';

const _phrases = [
  'Cero olvidos 🔒',
  'Al día, siempre ⚡',
  'Sin sorpresas 🎯',
  'Todo bajo control ✨',
  'Tu flota en forma 💪',
  'Organizado y listo 🚀',
  'Sin pendientes 🎉',
  'Tú cuidas, Manti recuerda 🧠',
];

String _dailyPhrase() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  return _phrases[dayOfYear % _phrases.length];
}

class SummaryCard extends StatelessWidget {
  final int totalItems;
  final int overdueCount;

  const SummaryCard({
    super.key,
    required this.totalItems,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onTime = totalItems - overdueCount;
    final isGood = overdueCount == 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Resúmen',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              // Static "🤖 Manti" line
              Text(
                '🤖 Manti',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),

              // Animated second line
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ));
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: Text(
                  isGood
                      ? _dailyPhrase()
                      : '$overdueCount pendiente${overdueCount == 1 ? '' : 's'} ⚙️',
                  key: ValueKey(isGood),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _StatusChip(
                    icon: Icons.check_circle_rounded,
                    label: '$onTime al día',
                    color: Colors.green,
                  ),
                  if (overdueCount > 0) ...[
                    const SizedBox(width: 8),
                    _StatusChip(
                      icon: Icons.warning_amber_rounded,
                      label:
                          '$overdueCount atrasado${overdueCount == 1 ? '' : 's'}',
                      color: Colors.orange,
                    ),
                  ],
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
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.withValues(alpha: 0.85)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
