import '../../eva/eva.dart';

import 'development_environment.dart';

/// This is the production environment.
///
/// The only difference between the production and development environment
/// is the `minLogLevel`, which is `LogLevel.info` in this one (verbose
/// and debug logs will not be executed)
@immutable
class ProductionEnvironment extends DevelopmentEnvironment {
  const ProductionEnvironment();

  /// This overrides the minimum log-level behavior from the
  /// `DevelopmentEnvironment` environment.
  @override
  LogLevel get minLogLevel => LogLevel.info;
}
