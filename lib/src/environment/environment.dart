import 'dart:isolate';

import 'package:flutter/foundation.dart';

import '../../eva.dart';

/// An environment is a class that configures all your dependencies and injections
///
/// It serves the purpose to configure your app to run on different stages, such as
/// tests, development, production, homologation, etc. when those environments have
/// different settings or injections (URLs, different repository implementations, etc.)
@immutable
abstract class Environment {
  const Environment();

  /// When overridden to `true`, allows the execution of an environment in the main thread.
  ///
  /// This should ONLY be used for unit testing purposes!!!
  bool get allowRunInMainIsolate => false;

  /// This method is called when you use `Eva.useEnvironment()`, just after the `registerDependencies`.
  ///
  /// The `required` function returns the concrete class registered by `registerDependencies`
  ///
  /// `platform` will allow you to know if you are running Flutter web, desktop or mobile and in which
  /// kind of device (Android, iOS, Windows, MacOS or Linux)
  @mustCallSuper
  Future<void> initialize(RequiredFactory required, PlatformInfo platform);

  /// This method is called when you use `Eva.useEnvironment()`, just before the `initialize`.
  ///
  /// Here you will register all your dependencies using the `registerDependency` method.
  @mustCallSuper
  void registerDependencies();

  /// Configures the min `LogLevel` for this environment.
  LogLevel get minLogLevel;

  /// Register a dependency to be injected by `required` functions arguments.
  ///
  /// For example: `registerDependency<IRepo>((required, platform) => MyRepo(someDependency: required<ISomeDependency>()))`
  /// will register the concrete class `MyRepo` to be created whenever an `IRepo` is required. During this creation, it will
  /// create a concrete object of another registered dependency `ISomeDependency` and pass it on the `MyRepo` constructor
  ///
  /// It doesn't matter the order you register your dependencies, as long you do inside the `registerDependencies` method.
  @protected
  void registerDependency<TService>(TService Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) constructor) {
    if (DomainIsolateController.useMultithreading && allowRunInMainIsolate == false && Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    ServiceProvider.registerOrReplaceSingleton((optional, required, platform) => constructor(required, platform));
    Log.info(() => "Dependency `${TService}` will be satisfied by `${constructor.toString().split("=> ").last}`");
  }

  /// If for some reason you want to get an injected dependency on a context where you don't have a `required` argument,
  /// this method will allow it (it is basically the same thing as the `required` argument provided in most dependency
  /// injection aware methods)
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
        DomainIsolateController.dispatchEvent(event);
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
      DomainIsolateController.dispatchEvent(Event<UnexpectedExceptionEvent>.failure(ex));
    }
  }
}
