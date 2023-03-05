import 'package:eva/eva.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:eva_to_do_example/app/contracts/i_app_settings_repository.dart';
import 'package:eva_to_do_example/app/contracts/i_to_do_repository.dart';
import 'package:eva_to_do_example/app/environments/base_environment.dart';
import 'package:eva_to_do_example/app/repositories/in_memory_app_settings_repository.dart';
import 'package:eva_to_do_example/app/repositories/in_memory_to_do_repository.dart';

import "test_environment.mocks.dart";

@immutable
class TestEnvironment extends BaseEnvironment {
  const TestEnvironment();

  @override
  LogLevel get minLogLevel => LogLevel.verbose;

  @override
  void registerDependencies() {
    super.registerDependencies();

    registerDependency<IAppSettingsRepository>(
      (required, platform) => const InMemoryAppSettingsRepository(),
    );

    registerDependency<IToDoRepository>(
      (required, platform) => const InMemoryToDoRepository(),
    );
  }

  @override
  Future<void> initialize(RequiredFactory required, PlatformInfo platform) async {}
}
