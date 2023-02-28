import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../domain/theme_domain.dart';
import '../repositories/in_memory_app_settings_repository.dart';

@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  @override
  @mustCallSuper
  Future<void> initialize() async {
    await super.initialize();
    Log.info(() => "`BaseEnvironment` is initializing");

    registerDependency<IAppSettingsRepository>(
      (requires, platform) => const InMemoryAppSettingsRepository(),
    );

    registerDependency<ThemeDomain>(
      (requires, platform) => ThemeDomain(appSettingsRepository: requires<IAppSettingsRepository>()),
    );
  }
}
