import 'package:eva/eva.dart';
import 'package:mockito/annotations.dart';

import 'package:eva_to_do_example/app/contracts/i_app_settings_repository.dart';
import 'package:eva_to_do_example/app/contracts/i_to_do_repository.dart';
import 'package:eva_to_do_example/app/environments/base_environment.dart';

@GenerateNiceMocks([MockSpec<IAppSettingsRepository>(), MockSpec<IToDoRepository>()])
import "test_environment.mocks.dart";

@immutable
class TestEnvironment extends BaseEnvironment {
  const TestEnvironment();

  /// You MUST override this to `true` to be able to test
  /// your domain in your unit test isolate (main)
  @override
  bool get allowRunInMainIsolate => true;

  @override
  LogLevel get minLogLevel => LogLevel.verbose;

  @override
  void registerDependencies() {
    super.registerDependencies();

    registerDependency<IAppSettingsRepository>(
      (required, platform) => MockIAppSettingsRepository(),
    );

    registerDependency<IToDoRepository>(
      (required, platform) => MockIToDoRepository(),
    );
  }

  @override
  Future<void> initialize(RequiredFactory required, PlatformInfo platform) async {}
}
