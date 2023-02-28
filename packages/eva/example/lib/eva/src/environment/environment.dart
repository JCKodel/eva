import 'dart:isolate';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:meta/meta.dart';

import '../log/log.dart';

@immutable
abstract class Environment {
  const Environment();

  @mustCallSuper
  Future<void> initialize() async {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    Log.info(() => "Environment `${runtimeType}` is initializing");
  }

  void registerDependency<TService>(TService Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) constructor) {
    ServiceProvider.registerOrReplaceSingleton((optional, required, platform) => constructor(required, platform));
    Log.debug(() => "Dependency `${TService}` will be satisfied by `${constructor.toString().split("=> ").last}`");
  }

  TService required<TService>() {
    return ServiceProvider.required<TService>();
  }
}
