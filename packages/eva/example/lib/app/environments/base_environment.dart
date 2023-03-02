import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';
import '../domain/to_do_domain.dart';
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

    registerDependency<SettingsDomain>(
      (requires, platform) => SettingsDomain(appSettingsRepository: requires<IAppSettingsRepository>()),
    );

    registerDependency<IToDoRepository>(
      (requires, platform) => const InMemoryToDoRepository(),
    );

    registerDependency<ToDoDomain>(
      (requires, platform) => ToDoDomain(toDoRepository: requires<IToDoRepository>()),
    );
  }
}
