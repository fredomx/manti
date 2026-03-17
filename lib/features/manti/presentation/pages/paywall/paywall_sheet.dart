import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manti/core/config/app_config.dart';
import 'package:manti/core/services/entitlements_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Shows the paywall and returns `true` if the user successfully unlocks Pro.
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _PaywallSheet(),
  );
  return result ?? false;
}

class _PaywallSheet extends StatefulWidget {
  const _PaywallSheet();

  @override
  State<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<_PaywallSheet> {
  Package? _package;
  bool _loadingPackage = true;
  bool _loadError = false;
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  Future<void> _loadPackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      debugPrint('[Paywall] current offering: ${offerings.current?.identifier}');
      debugPrint('[Paywall] packages: ${offerings.current?.availablePackages.map((p) => p.identifier).toList()}');
      if (mounted) {
        setState(() {
          _package = offerings.current?.availablePackages.firstOrNull;
          _loadingPackage = false;
          _loadError = _package == null;
        });
      }
    } catch (e) {
      debugPrint('[Paywall] error loading offerings: $e');
      if (mounted) setState(() { _loadingPackage = false; _loadError = true; });
    }
  }

  Future<void> _purchase() async {
    final package = _package;
    if (package == null) return;
    setState(() => _purchasing = true);
    try {
      final bought = await EntitlementsService.instance.purchase(package);
      if (mounted) Navigator.of(context).pop(bought);
    } on PurchasesError catch (e) {
      if (e.code == PurchasesErrorCode.purchaseCancelledError) {
        // User cancelled — silent
      } else if (mounted) {
        _showError('No se pudo completar la compra.');
      }
    } catch (_) {
      if (mounted) _showError('No se pudo completar la compra.');
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _purchasing = true);
    try {
      final restored = await EntitlementsService.instance.restore();
      if (mounted) {
        if (restored) {
          Navigator.of(context).pop(true);
        } else {
          _showError('No se encontró ninguna compra anterior.');
        }
      }
    } catch (_) {
      if (mounted) _showError('No se pudo restaurar la compra.');
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String get _priceLabel {
    final price = _package?.storeProduct.priceString;
    if (price == null) return 'Obtener Pro';
    return 'Una sola compra · $price';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            28, 20, 28,
            28 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 28),

              // Crown icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFE6A817),
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Manti Pro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cuida todo lo que importa, sin límites.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 28),

              // Feature list
              _FeatureRow(
                icon: Icons.grid_view_rounded,
                color: const Color(0xFF0A84FF),
                title: 'Artículos ilimitados',
                subtitle: 'Sin límite de 3 artículos',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.notifications_rounded,
                color: const Color(0xFF34C759),
                title: 'Recordatorios ilimitados',
                subtitle: 'Para todos tus artículos y servicios',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.cloud_upload_rounded,
                color: const Color(0xFF5856D6),
                title: 'Copia de seguridad',
                subtitle: 'Exporta y restaura todos tus datos',
              ),
              const SizedBox(height: 32),

              // Buy button
              SizedBox(
                width: double.infinity,
                child: _purchasing || _loadingPackage
                    ? const Center(child: CircularProgressIndicator())
                    : _loadError
                        ? AppConfig.isDev
                            ? FilledButton(
                                onPressed: () async {
                                  final bought = await EntitlementsService.instance.debugUnlockPro();
                                  if (context.mounted) Navigator.of(context).pop(bought);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: const StadiumBorder(),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('[DEBUG] Simular compra Pro'),
                              )
                            : Text(
                                'Producto no disponible. Inténtalo más tarde.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                              )
                        : FilledButton(
                            onPressed: _purchase,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const StadiumBorder(),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: Text(_priceLabel),
                          ),
              ),
              const SizedBox(height: 12),

              // Restore
              TextButton(
                onPressed: _purchasing ? null : _restore,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black38,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'Restaurar compras',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
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
        const Icon(Icons.check_circle_rounded, color: Color(0xFF34C759), size: 20),
      ],
    );
  }
}
