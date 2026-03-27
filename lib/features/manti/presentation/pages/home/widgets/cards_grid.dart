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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Aún no tienes artículos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Agrega lo que quieres mantener al día.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black38,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
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
                  Text('Agregar artículo'),
                ],
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

