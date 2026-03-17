import 'package:flutter/material.dart';

/// Shows a glass-styled confirmation dialog for destructive deletes.
///
/// [title] – what is being deleted (e.g. the item/log name).
/// Returns `true` if the user confirms, `false` / `null` otherwise.
Future<bool> showDeleteConfirmDialog(
  BuildContext context, {
  required String title,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white.withValues(alpha: 0.85),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1,
        ),
      ),
      title: const Text(
        '¿Eliminar?',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: Colors.black87,
        ),
      ),
      content: Text(
        'Se eliminará "$title" de forma permanente.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.5),
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(
            'Eliminar',
            style: TextStyle(
              color: Color(0xFFFF3B30),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  ).then((v) => v ?? false);
}
