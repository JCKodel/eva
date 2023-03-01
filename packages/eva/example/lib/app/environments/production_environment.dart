import '../../eva/eva.dart';

import 'development_environment.dart';

@immutable
class ProductionEnvironment extends DevelopmentEnvironment {
  const ProductionEnvironment();

  @override
  LogLevel get minLogLevel => LogLevel.info;
}
