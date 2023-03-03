import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../repositories/isar/isar_app_settings_repository.dart';
import '../repositories/isar/isar_to_do_repository.dart';

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
      (required, platform) => IsarAppSettingsRepository(),
    );

    registerDependency<IToDoRepository>(
      (required, platform) => IsarToDoRepository(),
    );
  }

  @override
  Future<void> initialize(required, platform) async {
    await Future.wait([
      required<IAppSettingsRepository>().initialize(),
      required<IToDoRepository>().initialize(),
    ]);
  }
}
