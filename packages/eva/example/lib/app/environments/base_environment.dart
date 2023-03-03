import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';
import '../domain/to_do_domain.dart';

@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  @override
  Future<void> registerDependencies() async {
    registerDependency<SettingsDomain>(
      (required, platform) => SettingsDomain(appSettingsRepository: required<IAppSettingsRepository>()),
    );

    registerDependency<ToDoDomain>(
      (required, platform) => ToDoDomain(
        toDoRepository: required<IToDoRepository>(),
        settingsDomain: required<SettingsDomain>(),
      ),
    );
  }
}
