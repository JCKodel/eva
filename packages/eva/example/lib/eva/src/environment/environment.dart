import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import '../../eva.dart';

@immutable
abstract class Environment {
  const Environment();

  static final _commandHandlers = <Type, ICommandHandler Function(TConcrete Function<TConcrete>() required, PlatformInfo platform)>{};

  @mustCallSuper
  Future<void> initialize();

  @mustCallSuper
  void registerDependencies();

  @mustCallSuper
  void registerCommandHandlers();

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
  void registerCommandHandler<T>(ICommandHandler Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) commandHandlerConstructor) {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    _commandHandlers[T] = commandHandlerConstructor;
    Log.info(
      () => "Event `Event<${T}>` will be handled by "
          "`${commandHandlerConstructor.toString().replaceFirst("Closure: (<Y0>() => Y0, PlatformInfo) => ", "")}`",
    );
  }

  @protected
  void onMessageReceived(dynamic message) {
    final command = message as Command;
    final handler = _commandHandlers[command.runtimeType];

    if (handler == null) {
      final errorMessage = "Domain received command `${command.runtimeType}` but no handler was registered to process it";

      Log.error(() => errorMessage);

      if (kDebugMode) {
        throw UnimplementedError(errorMessage);
      }
      return;
    }

    Log.debug(() => "Domain received command `${command.runtimeType}`");

    try {
      // ignore: invalid_use_of_protected_member
      final commandHandler = handler(ServiceProvider.required, PlatformInfo.platformInfo) as CommandHandler;
      final outputStream = commandHandler.handle(command);

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
