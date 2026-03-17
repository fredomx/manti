import 'package:manti/bootstrap.dart';
import 'package:manti/core/config/app_config.dart';
import 'package:manti/core/config/flavor.dart';

void main() {
  AppConfig.flavor = Flavor.production;
  bootstrap();
}
