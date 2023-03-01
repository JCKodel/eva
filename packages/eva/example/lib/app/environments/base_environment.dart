import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/theme_domain.dart';
import '../domain/to_do_domain.dart';
import '../presentation/commands/load_theme_command.dart';
import '../presentation/commands/load_to_dos_command.dart';
import '../presentation/commands/save_theme_command.dart';
import '../repositories/in_memory_app_settings_repository.dart';
import '../repositories/in_memory_to_do_repository.dart';

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

    registerDependency<IToDoRepository>(
      (requires, platform) => const InMemoryToDoRepository(),
    );

    registerDependency<ToDoDomain>(
      (requires, platform) => ToDoDomain(toDoRepository: requires<IToDoRepository>()),
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

    registerCommandHandler<LoadToDosCommand>(
      (required, platform) => LoadToDosCommandHandler(toDoDomain: required<ToDoDomain>()),
    );
  }
}
