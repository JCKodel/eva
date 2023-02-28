import '../../eva/eva.dart';

import 'base_environment.dart';

@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  @override
  LogLevel get minLogLevel => LogLevel.verbose;
}
