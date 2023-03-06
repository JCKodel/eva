import 'package:eva/eva.dart';

import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';
import '../repositories/isar/isar_app_settings_repository.dart';
import '../repositories/isar/isar_to_do_repository.dart';

/// This is a base class (it's YOUR code) to register dependencies
/// that are shared among all environments, just for the sake of DRY
import 'base_environment.dart';

/// This is the environment used for development, using a real database
///
/// This is inherited from BaseEnvironment because there are common things
/// between all environments, so, the best practice is to register anything
/// common to all environments and then only override and specialize what
/// is needed for the new environment
@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  /// Default `minLogLevel` for Eva is `LogLevel.debug`, so
  /// we are specifiying we want more log here
  @override
  LogLevel get minLogLevel => LogLevel.verbose;

  /// STEP#2:
  /// This is the first method Eva calls and you should only register your
  /// dependencies here. We use the `kfx_dependency_injection` package
  /// and all dependencies will be registered as a singleton (so, don't
  /// keep states in your dependencies)
  ///
  /// Usually, here we say which class will be returned whenever we ask for
  /// a repository contract (since this is a base class for all our environments,
  /// except test, we're returning the Isar database repositories)
  ///
  /// For example: if you have a repository that handles API calls, you could
  /// either create a `DevelopmentAPIRepository`, with a String pointing to
  /// your dev API server and a `ProductionAPIRepository` with an URL pointing
  /// to your production server, or you can just create an `APIRepository` that
  /// receives a URL as a parameter and configures that argument inside your dev,
  /// homolog, prod, etc. environments using, for example,
  /// `(required, platform) => APIRepository(serverUrl: "https://example.com")`
  @override
  void registerDependencies() {
    // Notice that you MUST call `super.registerDependencies` and Dart will
    // remind you (if you configure analysis correctly) because `Environment`
    // has a `@mustCallSuper` meta-annotation on it. We recommend using the
    // `analysis_options.yaml` file provided by this project so you can get
    // all warnings for best practices.
    super.registerDependencies();

    // A dependency registration is pretty easy:
    // Here, whenever someone requires an `IAppSettingsRepository` (an abstract
    // empty class, i.e. an interface), an `IsarAppSettingsRepository` will be
    // returned (this class implements the interface above). Think of this as
    // plugins: you can choose whatever an environment returns from a need for
    // a type, depending on your environment needs (for instance: for unit
    // tests, you would not return a real database repository)
    registerDependency<IAppSettingsRepository>(
      (required, platform) => IsarAppSettingsRepository(),
    );

    registerDependency<IToDoRepository>(
      (required, platform) => IsarToDoRepository(),
    );
  }

  /// STEP#3:
  /// This method runs just after the `registerDependencies` above, and
  /// it allows you to initialize things before anything.
  ///
  /// Here, we are calling our repositories because the Isar database
  /// requires some initialization.
  ///
  /// Here is the place to run database migrations or read some initial
  /// values from platform plugins (such as GPS, FirebaseAnalytics, etc.).
  ///
  /// Of course, this initialization isn't required, so you just can
  /// ignore it if you don't have any initialization.
  @override
  Future<void> initialize(required, platform) async {
    await Future.wait([
      required<IAppSettingsRepository>().initialize(),
      required<IToDoRepository>().initialize(),
    ]);
  }
}
