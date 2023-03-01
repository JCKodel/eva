import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../domain/theme_domain.dart';
import '../presentation/commands/load_theme_command.dart';
import '../presentation/commands/save_theme_command.dart';
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
  void registerCommandHandlers() {
    registerCommandHandler<LoadThemeCommand>(
      (required, platform) => LoadThemeCommandHandler(themeDomain: required<ThemeDomain>()),
    );

    registerCommandHandler<SaveThemeCommand>(
      (required, platform) => SaveThemeCommandHandler(themeDomain: required<ThemeDomain>()),
    );
  }
}
