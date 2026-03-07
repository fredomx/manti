
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/widgets/manti_card.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';
import 'package:manti/features/manti/presentation/pages/maintenance_log/maintenance_log_screen.dart';
import 'package:manti/features/manti/presentation/pages/new_item/new_item_sheet.dart';

class CardsGrid extends StatelessWidget {
  final List<MantiItem> items;
  final bool isLoading;

  const CardsGrid({super.key, required this.items, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro text
            Text(
              'Bienvenido a Manti',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu asistente personal de mantenimiento. Sigue estos pasos para empezar:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black45,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Steps
            _OnboardingStep(
              number: '1',
              title: 'Agrega un artículo',
              body: 'Toca el botón +, ponle nombre, elige categoría, ícono y color. Puede ser tu auto, laptop, cafetera — lo que uses.',
              color: const Color(0xFF0A84FF),
            ),
            const SizedBox(height: 10),
            _OnboardingStep(
              number: '2',
              title: 'Registra cada mantenimiento',
              body: 'Abre el artículo y toca + cada vez que hagas un servicio. Anota el título, costo y notas del trabajo realizado.',
              color: const Color(0xFF30B0C7),
            ),
            const SizedBox(height: 10),
            _OnboardingStep(
              number: '3',
              title: 'Activa la frecuencia por servicio',
              body: 'Al crear un registro, asígnale una frecuencia (ej. cada 3 meses). Manti calculará la próxima fecha y te avisará cuando se acerque.',
              color: const Color(0xFF34C759),
            ),
            const SizedBox(height: 24),

            // CTA
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => showNewItemSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Agregar mi primer artículo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 4 / 4,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return MantiCard(
          item: item,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MaintenanceLogScreen(item: item),
            ),
          ),
          onEdit: () => showEditItemSheet(context, item),
          onDelete: () => context.read<ItemsCubit>().deleteItem(item.idLocal),
        );
      },
    );
  }
}

// ── Onboarding step card ──────────────────────────────────────────────────────

class _OnboardingStep extends StatelessWidget {
  final String number;
  final String title;
  final String body;
  final Color color;

  const _OnboardingStep({
    required this.number,
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number bubble
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withValues(alpha: 0.45),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
