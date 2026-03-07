import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Isar Schemas
import 'package:manti/features/manti/data/local/manti_item_isar.dart';
import 'package:manti/features/manti/data/local/maintenance_log_isar.dart';
import 'package:manti/features/manti/data/local/app_config_isar.dart';

// Local Data Sources
import 'package:manti/features/manti/data/local/items_local_data_source.dart';

// Cubits
import 'package:manti/features/manti/presentation/cubit/items_cubit.dart';

// UI
import 'package:manti/features/manti/presentation/pages/home/home_screen.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Directory for Isar
  final dir = await getApplicationDocumentsDirectory();

  // Open Isar with all schemas
  final isar = await Isar.open(
    [
      MantiItemIsarSchema,
      MaintenanceLogIsarSchema,
      AppConfigIsarSchema,
    ],
    directory: dir.path,
  );

  runApp(
    RepositoryProvider<Isar>.value(
      value: isar,
      child: BlocProvider(
        create: (_) => ItemsCubit(ItemsLocalDataSource(isar)),
        child: const MantiApp(),
      ),
    ),
  );
}

class MantiApp extends StatelessWidget {
  const MantiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manti',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
