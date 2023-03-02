import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import '../../eva.dart';

@immutable
abstract class Environment {
  const Environment();

  @mustCallSuper
  Future<void> initialize();

  @mustCallSuper
  void registerDependencies();

  LogLevel get minLogLevel;

  @protected
  void registerDependency<TService>(TService Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) constructor) {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    ServiceProvider.registerOrReplaceSingleton((optional, required, platform) => constructor(required, platform));
    Log.info(() => "Dependency `${TService}` will be satisfied by `${constructor.toString().split("=> ").last}`");
  }

  @protected
  TService getDependency<TService>() {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    return ServiceProvider.required<TService>();
  }

  @protected
  void onMessageReceived(dynamic message) {
    final command = message as Command;

    Log.debug(() => "Domain received command `${command.runtimeType}`");

    try {
      // ignore: invalid_use_of_protected_member
      final outputStream = command.handle(ServiceProvider.required, PlatformInfo.platformInfo);

      outputStream.forEach((event) {
        Log.debug(() => "Event `${event.runtimeType}` emitted `${event.runtimeType}`");

        // ignore: invalid_use_of_protected_member
        Domain.dispatchEvent(event);
      });
    } catch (ex) {
      late String exceptionMessage;

      try {
        exceptionMessage = (ex as dynamic).message as String;
      } catch (_) {
        exceptionMessage = ex.toString();
      }

      Log.error(() => "Command `${command.runtimeType}` threw `${ex.runtimeType}`\n${exceptionMessage}");
      Log.verbose(() => command.toString());

      if (kDebugMode) {
        rethrow;
      }

      // ignore: invalid_use_of_protected_member
      Domain.dispatchEvent(Event<UnexpectedExceptionEvent>.failure(ex));
    }
  }
}
