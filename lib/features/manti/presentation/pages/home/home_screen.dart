import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manti/core/ui/app_scaffold.dart';
import 'package:manti/core/utils/date_utils.dart';
import 'package:manti/core/ui/buttons/manti_glass_fab.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';
import 'package:manti/features/manti/presentation/cubit/items_state.dart';
import '../new_item/new_item_sheet.dart' show showNewItemSheet;
import 'home_exports.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: const _HomeContent(),
      floatingButton: MantiGlassFab(
        icon: Icons.add_rounded,
        label: 'Agregar',
        onPressed: () => showNewItemSheet(context),
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
