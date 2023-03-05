import 'package:eva/eva.dart';

import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';
import '../domain/to_do_domain.dart';

/// This is a base class for all our environments because Domain classes
/// usually are always concrete, so you don't really need to segregate
/// then using interfaces (you could if you wanted to).
///
/// In this example, all environments are const (stateless), but you can
/// make them stateful, if you wish (just keep in mind that those classes
/// are singleton, i.e.: they are instantiated only once)
@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  /// Since this is a base class, this method will be called
  /// before the `registerDependencies` of any inherited class
  /// although this doesn't matter at all, since registration
  /// can be called in any order.
  @override
  void registerDependencies() {
    registerDependency<SettingsDomain>(
      (required, platform) => SettingsDomain(
        // the `required` argument here is used to require some previous
        // registered dependency, so, basically, we are saying here:
        //
        // Get whatever class we registered using
        // `registerDependency<IAppSettingsRepository>`
        //
        // In dev and prod environments, this means
        // IsarAppSettingsRepository. In test environment
        // this means InMemoryAppSettingsRepository (
        // which is a fake in-memory database for testing
        // purposes)
        //
        // `platform` will allow you to know if you are running
        // Flutter web, desktop or mobile and in which kind of
        // device (Android, iOS, Windows, MacOS or Linux)
        appSettingsRepository: required<IAppSettingsRepository>(),
      ),
    );

    registerDependency<ToDoDomain>(
      (required, platform) => ToDoDomain(
        toDoRepository: required<IToDoRepository>(),
        settingsDomain: required<SettingsDomain>(),
      ),
    );
  }
}
