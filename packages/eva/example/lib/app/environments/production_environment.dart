import '../../eva/eva.dart';

import 'base_environment.dart';

@immutable
class ProductionEnvironment extends BaseEnvironment {
  const ProductionEnvironment();

  @override
  LogLevel get minLogLevel => LogLevel.info;
}
