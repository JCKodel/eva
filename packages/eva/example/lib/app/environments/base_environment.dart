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
  Future<void> registerDependencies() async {
    registerDependency<IAppSettingsRepository>(
      (required, platform) => const InMemoryAppSettingsRepository(),
    );

    registerDependency<SettingsDomain>(
      (required, platform) => SettingsDomain(appSettingsRepository: required<IAppSettingsRepository>()),
    );

    registerDependency<IToDoRepository>(
      (required, platform) => const InMemoryToDoRepository(),
    );

    registerDependency<ToDoDomain>(
      (required, platform) => ToDoDomain(toDoRepository: required<IToDoRepository>()),
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
