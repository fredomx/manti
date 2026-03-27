import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/ui/gaps.dart';
import 'package:manti/core/utils/date_utils.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/logs_cubit.dart';

const _backgroundColor = Color(0xE6FFFFFF);
const _accentColor = Color(0xFF0A84FF);

Future<void> showNewLogSheet(
  BuildContext context,
  MantiCategory category,
) async {
  final logsCubit = context.read<LogsCubit>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: _backgroundColor,
    builder: (_) => _LogSheet(logsCubit: logsCubit, category: category),
  );
}

Future<void> showEditLogSheet(
  BuildContext context,
  MaintenanceLog log,
  MantiCategory category,
) async {
  final logsCubit = context.read<LogsCubit>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: _backgroundColor,
    builder: (_) => _LogSheet(logsCubit: logsCubit, existing: log, category: category),
  );
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

class _LogSheet extends StatefulWidget {
  final LogsCubit logsCubit;
  final MaintenanceLog? existing;
  final MantiCategory category;

  const _LogSheet({
    required this.logsCubit,
    required this.category,
    this.existing,
  });

  @override
  State<_LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<_LogSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late final TextEditingController _mileageController;
  late final TextEditingController _costController;
  late final TextEditingController _customFrequencyController;
  late DateTime _selectedDate;
  int? _selectedFrequencyDays;
  bool _customFrequencyMode = false;

  static const _presetDays = {30, 90, 180, 365, 730};

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final log = widget.existing;
    _titleController = TextEditingController(text: log?.title ?? '');
    _notesController = TextEditingController(text: log?.notes ?? '');
    _mileageController = TextEditingController(
      text: log?.mileage != null ? log!.mileage!.toStringAsFixed(0) : '',
    );
    _costController = TextEditingController(
      text: log?.cost != null ? log!.cost!.toStringAsFixed(2) : '',
    );
    _selectedDate = log?.date ?? DateTime.now();
    _selectedFrequencyDays = log?.frequencyDays;

    final isCustom = log?.frequencyDays != null &&
        !_presetDays.contains(log!.frequencyDays);
    _customFrequencyMode = isCustom;
    _customFrequencyController = TextEditingController(
      text: isCustom ? log.frequencyDays!.toString() : '',
    );
    _customFrequencyController.addListener(_onCustomFrequencyChanged);
  }

  void _onCustomFrequencyChanged() {
    if (!_customFrequencyMode) return;
    final days = int.tryParse(_customFrequencyController.text.trim());
    setState(() => _selectedFrequencyDays = (days != null && days > 0) ? days : null);
  }

  void _onPresetSelected(int? days) {
    setState(() {
      _selectedFrequencyDays = days;
      _customFrequencyMode = false;
      _customFrequencyController.clear();
    });
  }

  void _onCustomTap() {
    setState(() {
      _customFrequencyMode = true;
      final days = int.tryParse(_customFrequencyController.text.trim());
      _selectedFrequencyDays = (days != null && days > 0) ? days : null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _mileageController.dispose();
    _costController.dispose();
    _customFrequencyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();
    final mileage = double.tryParse(_mileageController.text.trim());
    final cost = double.tryParse(_costController.text.trim());

    if (_isEditing) {
      // Reconstruct so we can explicitly clear frequencyDays if unset
      await widget.logsCubit.updateLog(
        MaintenanceLog(
          idLocal: widget.existing!.idLocal,
          itemId: widget.existing!.itemId,
          date: _selectedDate,
          title: title.isEmpty ? null : title,
          notes: notes.isEmpty ? null : notes,
          mileage: mileage,
          cost: cost,
          frequencyDays: _selectedFrequencyDays,
          createdAt: widget.existing!.createdAt,
        ),
      );
    } else {
      await widget.logsCubit.addLog(
        date: _selectedDate,
        title: title.isEmpty ? null : title,
        notes: notes.isEmpty ? null : notes,
        mileage: mileage,
        cost: cost,
        frequencyDays: _selectedFrequencyDays,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    DateTime tempDate = _selectedDate;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),

            // Header: Cancel / Title / Done
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    'Fecha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _selectedDate = tempDate);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      'Listo',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cupertino wheel — allows past and future dates
            SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: DateTime(2000),
                maximumDate: DateTime.now().add(const Duration(days: 730)),
                onDateTimeChanged: (date) => tempDate = date,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => fmtDateShort(date);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isVehicle = widget.category == MantiCategory.vehicle;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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
            Gaps.v16,

            Text(
              _isEditing ? 'Editar registro' : 'Nuevo registro',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            Gaps.v24,

            const _FieldLabel('Título'),
            Gaps.v8,
            _PillField(
              controller: _titleController,
              hint: 'Ej. Cambio de aceite',
              textInputAction: TextInputAction.next,
            ),
            Gaps.v16,

            const _FieldLabel('Notas'),
            Gaps.v8,
            _PillField(
              controller: _notesController,
              hint: 'Detalles del mantenimiento...',
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            Gaps.v16,

            Row(
              children: [
                if (isVehicle) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Kilometraje'),
                        Gaps.v8,
                        _PillField(
                          controller: _mileageController,
                          hint: '0',
                          suffix: 'km',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  Gaps.h12,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Costo'),
                      Gaps.v8,
                      _PillField(
                        controller: _costController,
                        hint: '0.00',
                        prefix: '\$',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gaps.v16,

            const _FieldLabel('Fecha'),
            Gaps.v8,
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: _accentColor,
                      ),
                    ),
                    Gaps.h12,
                    Expanded(
                      child: Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v16,

            const _FieldLabel('Frecuencia'),
            Gaps.v8,
            _LogFrequencyPicker(
              selected: _selectedFrequencyDays,
              onSelected: _onPresetSelected,
              isCustomSelected: _customFrequencyMode,
              onCustomTap: _onCustomTap,
            ),
            if (_customFrequencyMode) ...[
              Gaps.v8,
              _PillField(
                controller: _customFrequencyController,
                hint: 'Ej. 45',
                suffix: 'días',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ],
            Gaps.v24,

            FilledButton(
              onPressed: _save,
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
              child: const Text('Guardar'),
            ),
            Gaps.v8,

            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black45,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// ── Frequency picker ──────────────────────────────────────────────────────────

class _LogFrequencyPicker extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelected;
  final bool isCustomSelected;
  final VoidCallback onCustomTap;

  const _LogFrequencyPicker({
    required this.selected,
    required this.onSelected,
    required this.isCustomSelected,
    required this.onCustomTap,
  });

  static const _options = <({String label, int days})>[
    (label: '1 mes', days: 30),
    (label: '3 meses', days: 90),
    (label: '6 meses', days: 180),
    (label: '1 año', days: 365),
    (label: '2 años', days: 730),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FreqChip(
            label: 'Ninguna',
            icon: Icons.block_rounded,
            isSelected: !isCustomSelected && selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ..._options.map((opt) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FreqChip(
              label: opt.label,
              icon: Icons.schedule_rounded,
              isSelected: !isCustomSelected && selected == opt.days,
              onTap: () => onSelected(opt.days),
            ),
          )),
          _FreqChip(
            label: 'Personalizado',
            icon: Icons.edit_rounded,
            isSelected: isCustomSelected,
            onTap: onCustomTap,
          ),
        ],
      ),
    );
  }
}

class _FreqChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FreqChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withValues(alpha: 0.85)
              : Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.1,
        color: Colors.black54,
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? prefix;
  final String? suffix;
  final TextInputAction? textInputAction;

  const _PillField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      onSubmitted: (_) {
        if (textInputAction == TextInputAction.done) {
          FocusScope.of(context).unfocus();
        }
      },
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.normal,
        ),
        prefixText: prefix,
        suffixText: suffix,
        prefixStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        suffixStyle: const TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 999),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
