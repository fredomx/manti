import 'package:isar/isar.dart';

part 'app_config_isar.g.dart';

@collection
class AppConfigIsar {
  Id id = 1;

  bool hasSeededMantiItems = false;

  List<int> completedTipIndices = [];
}
