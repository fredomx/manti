import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/services/backup_service.dart';
import 'package:manti/core/ui/dialogs/confirm_delete_dialog.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/data/local/logs_local_data_source.dart';

Future<void> showBackupSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _BackupSheet(
      service: BackupService(
        ItemsLocalDataSource(context.read<Isar>()),
        LogsLocalDataSource(context.read<Isar>()),
      ),
    ),
  );
}

class _BackupSheet extends StatefulWidget {
  final BackupService service;
  const _BackupSheet({required this.service});

  @override
  State<_BackupSheet> createState() => _BackupSheetState();
}

class _BackupSheetState extends State<_BackupSheet> {
  bool _loading = false;

  Future<void> _export() async {
    setState(() => _loading = true);
    try {
      await widget.service.export();
    } catch (e) {
      if (mounted) _showError('No se pudo exportar la copia.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    final confirmed = await showDeleteConfirmDialog(
      context,
      title: 'todos los datos actuales',
    );
    if (!confirmed || !mounted) return;

    setState(() => _loading = true);
    try {
      final restored = await widget.service.restore();
      if (mounted && restored) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos restaurados correctamente.')),
        );
      }
    } on FormatException catch (e) {
      if (mounted) _showError(e.message);
    } catch (_) {
      if (mounted) _showError('No se pudo restaurar la copia.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Copia de seguridad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Exporta todos tus artículos y registros a un archivo JSON que puedes guardar en iCloud, Google Drive o cualquier otro servicio.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withValues(alpha: 0.45),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              if (_loading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _ActionTile(
                  icon: Icons.upload_rounded,
                  title: 'Exportar copia',
                  subtitle: 'Guarda tus datos en un archivo .json',
                  onTap: _export,
                ),
                const SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.download_rounded,
                  title: 'Restaurar desde archivo',
                  subtitle: 'Reemplaza los datos actuales con una copia anterior',
                  onTap: _restore,
                  destructive: true,
                ),
              ],

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? const Color(0xFFFF3B30) : const Color(0xFF0A84FF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: destructive ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black.withValues(alpha: 0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
