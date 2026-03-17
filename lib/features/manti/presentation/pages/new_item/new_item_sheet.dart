import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/ui/gaps.dart';

import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';
import 'package:manti/core/widgets/color_picker.dart';
import 'package:manti/core/widgets/manti_icons.dart';
import 'package:manti/features/manti/presentation/pages/new_item/widgets/category_chips.dart';

const _backgroundColor = Color(0xE6FFFFFF);
const _accentColor = Color(0xFF0A84FF);

Future<void> showNewItemSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: _backgroundColor,
    builder: (_) => const _ItemSheet(),
  );
}

Future<void> showEditItemSheet(BuildContext context, MantiItem item) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: _backgroundColor,
    builder: (_) => _ItemSheet(existing: item),
  );
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

class _ItemSheet extends StatefulWidget {
  final MantiItem? existing;

  const _ItemSheet({this.existing});

  @override
  State<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<_ItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _customCategoryController;
  final _formKey = GlobalKey<FormState>();

  late MantiCategory _selectedCategory;
  late String _selectedIconName;
  late Color _selectedColor;

  bool get _isEditing => widget.existing != null;
  bool get _isOther => _selectedCategory == MantiCategory.other;

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    _nameController = TextEditingController(text: ex?.name ?? '');
    _customCategoryController =
        TextEditingController(text: ex?.customCategory ?? '');
    _selectedCategory = ex?.category ?? MantiCategory.vehicle;
    _selectedIconName =
        ex?.iconName ?? defaultIconName(_selectedCategory);
    _selectedColor = ex != null
        ? Color(ex.colorValue)
        : ColorPickerBar.palette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: _backgroundColor,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _IconPickerSheet(current: _selectedIconName),
    );
    if (result != null) setState(() => _selectedIconName = result);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();

    final customCategory = _isOther
        ? (_customCategoryController.text.trim().isEmpty
            ? null
            : _customCategoryController.text.trim())
        : null;

    if (_isEditing) {
      final updated = widget.existing!.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        customCategory: customCategory,
        iconName: _selectedIconName,
        colorValue: _selectedColor.toARGB32(),
        updatedAt: now,
      );
      await context.read<ItemsCubit>().updateItem(updated);
    } else {
      final item = MantiItem(
        idLocal: now.microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        customCategory: customCategory,
        createdAt: now,
        updatedAt: now,
        iconName: _selectedIconName,
        colorValue: _selectedColor.toARGB32(),
      );
      await context.read<ItemsCubit>().addItem(item);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderRow(isEditing: _isEditing),
            Gaps.v12,
            _PreviewCircle(
              iconName: _selectedIconName,
              color: _selectedColor,
              onTap: _pickIcon,
            ),
            Gaps.v12,
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _nameController.text.trim().isEmpty
                          ? (_isEditing ? 'Editar artículo' : 'Nuevo artículo')
                          : _nameController.text.trim(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gaps.v12,

                  const Text(
                    'Nombre',
                    style: TextStyle(fontSize: 12, letterSpacing: 1.1),
                  ),
                  Gaps.v4,

                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Ej. Toyota Corolla 2026',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.08),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe un nombre';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),

                  Gaps.v16,

                  CategoryChipsRow(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                        _selectedIconName = defaultIconName(cat);
                      });
                    },
                  ),

                  if (_isOther) ...[
                    Gaps.v12,
                    TextField(
                      controller: _customCategoryController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Ej. Jardín, Equipo de sonido...',
                        hintStyle: const TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.08),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],

                  Gaps.v16,

                  ColorPickerBar(
                    selectedColor: _selectedColor,
                    onColorSelected: (c) {
                      setState(() => _selectedColor = c);
                    },
                  ),

                  Gaps.v16,

                  _SaveButton(onPressed: _save, isEditing: _isEditing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _HeaderRow extends StatelessWidget {
  final bool isEditing;

  const _HeaderRow({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        const Spacer(),
        Text(
          isEditing ? 'Editar artículo' : 'Confirmar artículo',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _PreviewCircle extends StatelessWidget {
  final String iconName;
  final Color color;
  final VoidCallback? onTap;

  const _PreviewCircle({
    required this.iconName,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 5),
              ),
              child: Icon(iconForName(iconName), size: 72, color: color),
            ),
            if (onTap != null)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;

  const _SaveButton({required this.onPressed, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(isEditing ? 'Guardar cambios' : 'Guardar'),
      ),
    );
  }
}


// ── Icon picker sheet ─────────────────────────────────────────────────────────

class _IconPickerSheet extends StatelessWidget {
  final String current;

  const _IconPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Elige un ícono',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: mantiIconOptions.map((opt) {
                    final isSelected = current == opt.name;
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(opt.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withValues(alpha: 0.85)
                              : Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          opt.icon,
                          size: 26,
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
