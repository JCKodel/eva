import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../repositories/isar/isar_app_settings_repository.dart';

import 'base_environment.dart';

@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  @override
  LogLevel get minLogLevel => LogLevel.verbose;

  @override
  Future<void> registerDependencies() async {
    await super.registerDependencies();

    registerDependency<IAppSettingsRepository>(
      (requires, platform) => IsarAppSettingsRepository(),
    );
  }
}
