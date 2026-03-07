import 'package:flutter/material.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/core/widgets/manti_icons.dart';

String _categoryLabel(MantiCategory cat) {
  switch (cat) {
    case MantiCategory.tech:
      return 'Tech';
    case MantiCategory.vehicle:
      return 'Vehículo';
    case MantiCategory.tool:
      return 'Herramienta';
    case MantiCategory.home:
      return 'Hogar';
    case MantiCategory.other:
      return 'Otro';
  }
}

class CategoryChipsRow extends StatelessWidget {
  final MantiCategory selectedCategory;
  final ValueChanged<MantiCategory> onCategorySelected;

  const CategoryChipsRow({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: MantiCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = MantiCategory.values[index];
          final isSelected = selectedCategory == cat;

          return ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onCategorySelected(cat),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryIcon(cat),
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : Colors.black.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  _categoryLabel(cat),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Colors.black.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            selectedColor: Colors.black.withValues(alpha: 0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(
                color: isSelected
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.06),
              ),
            ),
            shadowColor: Colors.black.withValues(alpha: 0.06),
            elevation: 0,
          );
        },
      ),
    );
  }
}
