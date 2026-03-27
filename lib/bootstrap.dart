import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manti/core/config/app_config.dart';
import 'package:manti/core/services/entitlements_service.dart';
import 'package:manti/core/services/notification_service.dart';
import 'package:path_provider/path_provider.dart';

import 'package:manti/features/manti/data/local/manti_item_isar.dart';
import 'package:manti/features/manti/data/local/maintenance_log_isar.dart';
import 'package:manti/features/manti/data/local/app_config_isar.dart';
import 'package:manti/features/manti/data/local/items_local_data_source.dart';
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';
import 'package:manti/features/manti/presentation/pages/home/home_screen.dart';
import 'package:manti/features/manti/presentation/pages/onboarding/onboarding_screen.dart';
import 'core/theme/app_theme.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  NotificationService.instance.init();
  EntitlementsService.instance.init(AppConfig.revenueCatApiKey);

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MantiItemIsarSchema, MaintenanceLogIsarSchema, AppConfigIsarSchema],
    directory: dir.path,
  );

  final config = await isar.appConfigIsars.get(1);
  final showOnboarding = config?.hasSeededMantiItems != true;

  runApp(
    RepositoryProvider<Isar>.value(
      value: isar,
      child: BlocProvider(
        create: (_) => ItemsCubit(ItemsLocalDataSource(isar)),
        child: MantiApp(showOnboarding: showOnboarding),
      ),
    ),
  );
}

class MantiApp extends StatelessWidget {
  final bool showOnboarding;

  const MantiApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: AppConfig.isDev,
      title: 'Manti',
      theme: appTheme,
      home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
