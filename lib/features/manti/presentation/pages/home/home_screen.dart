import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/ui/app_scaffold.dart';
import 'package:manti/core/utils/date_utils.dart';
import 'package:manti/core/ui/buttons/manti_glass_fab.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';
import 'package:manti/features/manti/presentation/cubit/items_state.dart';
import 'package:manti/core/config/app_config.dart';
import 'package:manti/core/services/entitlements_service.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../backup/backup_sheet.dart';
import '../new_item/new_item_sheet.dart' show showNewItemSheet;
import '../paywall/paywall_sheet.dart';
import 'home_exports.dart';


void _showMoreMenu(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            showBackupSheet(context);
          },
          child: const Text('Copia de seguridad'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            RevenueCatUI.presentCustomerCenter();
          },
          child: const Text('Gestionar suscripción'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: const _HomeContent(),
      floatingButton: MantiGlassFab(
        icon: Icons.add_rounded,
        label: 'Agregar',
        onPressed: () async {
          final count = context.read<ItemsCubit>().state.items.length;
          if (count >= AppConfig.freeItemLimit &&
              !EntitlementsService.instance.isPro) {
            final bought = await showPaywallSheet(context);
            if (!bought || !context.mounted) return;
          }
          if (context.mounted) showNewItemSheet(context);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  String _todayLabel() => fmtDayLong(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          final items = state.items;
          final overdueCount = items
              .where((i) => i.status == MaintenanceStatus.overdue)
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting header
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hola 👋',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _todayLabel(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withValues(alpha: 0.35),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showMoreMenu(context),
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),

                SummaryCard(
                  totalItems: items.length,
                  overdueCount: overdueCount,
                ),
                const SizedBox(height: 14),
                ProgressCard(items: items),
                const SizedBox(height: 28),
                const GridHeader(),
                const SizedBox(height: 14),
                CardsGrid(items: items, isLoading: state.isLoading),
                const SizedBox(height: 160),
              ],
            ),
          );
        },
      ),
    );
  }
}
