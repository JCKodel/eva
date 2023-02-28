import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../domain/theme_domain.dart';
import '../presentation/events/load_theme.dart';
import '../presentation/events/save_theme.dart';
import '../repositories/in_memory_app_settings_repository.dart';

@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> registerDependencies() async {
    registerDependency<IAppSettingsRepository>(
      (requires, platform) => const InMemoryAppSettingsRepository(),
    );

    registerDependency<ThemeDomain>(
      (requires, platform) => ThemeDomain(appSettingsRepository: requires<IAppSettingsRepository>()),
    );
  }

  @override
  void registerEventHandlers() {
    registerEventHandler<LoadTheme>(
      (required, platform) => LoadThemeEventHandler(themeDomain: required<ThemeDomain>()),
    );

    registerEventHandler<SaveTheme>(
      (required, platform) => SaveThemeEventHandler(themeDomain: required<ThemeDomain>()),
    );
  }
}
