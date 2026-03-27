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

enum _LogMode { logged, upcoming }

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
    builder: (_) =>
        _LogSheet(logsCubit: logsCubit, existing: log, category: category),
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
  late _LogMode _mode;
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

    if (log != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final logDay = DateTime(log.date.year, log.date.month, log.date.day);
      _mode = logDay.isAfter(today) ? _LogMode.upcoming : _LogMode.logged;
    } else {
      _mode = _LogMode.logged;
    }

    final isCustom =
        log?.frequencyDays != null && !_presetDays.contains(log!.frequencyDays);
    _customFrequencyMode = isCustom;
    _customFrequencyController = TextEditingController(
      text: isCustom ? log.frequencyDays!.toString() : '',
    );
    _customFrequencyController.addListener(_onCustomFrequencyChanged);
  }

  void _onCustomFrequencyChanged() {
    if (!_customFrequencyMode) return;
    final days = int.tryParse(_customFrequencyController.text.trim());
    setState(
        () => _selectedFrequencyDays = (days != null && days > 0) ? days : null);
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

  void _switchMode(_LogMode mode) {
    if (_mode == mode) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    setState(() {
      _mode = mode;
      if (mode == _LogMode.upcoming && !selectedDay.isAfter(today)) {
        _selectedDate = now.add(const Duration(days: 7));
      } else if (mode == _LogMode.logged && selectedDay.isAfter(today)) {
        _selectedDate = now;
      }
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
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                        color: _accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    _mode == _LogMode.logged ? 'Cuándo' : 'Para cuándo',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: _mode == _LogMode.upcoming
                    ? DateTime.now().add(const Duration(days: 1))
                    : DateTime(2000),
                maximumDate: _mode == _LogMode.logged
                    ? DateTime.now()
                    : DateTime.now().add(const Duration(days: 730)),
                onDateTimeChanged: (date) => tempDate = date,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isVehicle = widget.category == MantiCategory.vehicle;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────
              _HeaderRow(
                title: _isEditing
                    ? (_mode == _LogMode.upcoming
                        ? 'Editar recordatorio'
                        : 'Editar registro')
                    : (_mode == _LogMode.upcoming
                        ? 'Nuevo recordatorio'
                        : 'Nuevo registro'),
              ),
              Gaps.v12,

              // ── Mode selector (new entries only) ─────────────────────
              if (!_isEditing) ...[
                _ModeSelector(mode: _mode, onChanged: _switchMode),
                Gaps.v16,
              ],

              // ── Título ───────────────────────────────────────────────
              const _SectionLabel('Título'),
              Gaps.v4,
              _PillField(
                controller: _titleController,
                hint: 'Ej. Cambio de aceite',
                textInputAction: TextInputAction.next,
              ),
              Gaps.v16,

              // ── Notas ────────────────────────────────────────────────
              const _SectionLabel('Notas'),
              Gaps.v4,
              _PillField(
                controller: _notesController,
                hint: 'Detalles opcionales...',
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              Gaps.v16,

              // ── Km / Costo (solo "ya lo hice") ───────────────────────
              if (_mode == _LogMode.logged) ...[
                Row(
                  children: [
                    if (isVehicle) ...[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionLabel('Kilometraje'),
                            Gaps.v4,
                            _PillField(
                              controller: _mileageController,
                              hint: '0',
                              suffix: 'km',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
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
                          const _SectionLabel('Costo'),
                          Gaps.v4,
                          _PillField(
                            controller: _costController,
                            hint: '0.00',
                            prefix: '\$',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.v16,
              ],

              // ── Fecha ────────────────────────────────────────────────
              _SectionLabel(
                  _mode == _LogMode.logged ? 'Cuándo' : 'Para cuándo'),
              Gaps.v4,
              _DateButton(
                  date: _selectedDate, mode: _mode, onTap: _pickDate),
              Gaps.v16,

              // ── Frecuencia ───────────────────────────────────────────
              const _SectionLabel('Repetir'),
              Gaps.v4,
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
              Gaps.v16,

              // ── Guardar ──────────────────────────────────────────────
              _SaveButton(
                label: _mode == _LogMode.upcoming
                    ? 'Guardar recordatorio'
                    : 'Guardar',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header row ────────────────────────────────────────────────────────────────

class _HeaderRow extends StatelessWidget {
  final String title;
  const _HeaderRow({required this.title});

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
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

// ── Mode selector ─────────────────────────────────────────────────────────────

class _ModeSelector extends StatelessWidget {
  final _LogMode mode;
  final ValueChanged<_LogMode> onChanged;

  const _ModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              label: 'Ya lo hice',
              icon: Icons.check_circle_outline_rounded,
              selected: mode == _LogMode.logged,
              onTap: () => onChanged(_LogMode.logged),
            ),
          ),
          Expanded(
            child: _ModeTab(
              label: 'Lo haré',
              icon: Icons.event_rounded,
              selected: mode == _LogMode.upcoming,
              onTap: () => onChanged(_LogMode.upcoming),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected
                  ? _accentColor
                  : Colors.black.withValues(alpha: 0.35),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? Colors.black87
                    : Colors.black.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date button ───────────────────────────────────────────────────────────────

class _DateButton extends StatelessWidget {
  final DateTime date;
  final _LogMode mode;
  final VoidCallback onTap;

  const _DateButton(
      {required this.date, required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(
              mode == _LogMode.upcoming
                  ? Icons.event_rounded
                  : Icons.calendar_today_rounded,
              size: 16,
              color: _accentColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fmtDateShort(date),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Save button ───────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SaveButton({required this.label, required this.onPressed});

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
        child: Text(label),
      ),
    );
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
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FreqChip(
            label: 'No',
            icon: Icons.block_rounded,
            isSelected: !isCustomSelected && selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ..._options.map((opt) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FreqChip(
                  label: opt.label,
                  icon: Icons.repeat_rounded,
                  isSelected: !isCustomSelected && selected == opt.days,
                  onTap: () => onSelected(opt.days),
                ),
              )),
          _FreqChip(
            label: 'Otro',
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _accentColor
              : Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected
                  ? Colors.white
                  : Colors.black.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pill input field ──────────────────────────────────────────────────────────

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
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        prefixText: prefix,
        suffixText: suffix,
        prefixStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        suffixStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(maxLines > 1 ? 20 : 999),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, letterSpacing: 1.1),
    );
  }
}
