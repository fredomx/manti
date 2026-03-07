import 'package:flutter/material.dart';

class ColorPickerBar extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerBar({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static const List<Color> palette = [
    Color(0xFF007AFF), // System Blue
    Color(0xFF34C759), // System Green
    Color(0xFFFF3B30), // System Red
    Color(0xFFFF9500), // System Orange
    Color(0xFF5856D6), // System Purple
    Color(0xFFFFCC00), // System Yellow
    Color(0xFF8E8E93), // System Gray
    Colors.black,      // Pure Black
    Color(0xFF30B0C7), // Teal Blue
    Color(0xFFBF5AF2), // Light Purple / Magenta
    Color(0xFF64D2FF), // Cyan / Light Blue
    Color(0xFFFF2D55), // Hot Pink
    Color(0xFFAF52DE), // Deep Violet
    Color(0xFFFFD60A), // Bright Yellow (lighter variant)
    Color(0xFFAEAEB2), // Light Gray
  ];


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: palette.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final color = palette[i];
          final isSelected = color == selectedColor;

          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isSelected ? 36 : 32,
              height: isSelected ? 36 : 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.black.withValues(alpha: 0.25)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
