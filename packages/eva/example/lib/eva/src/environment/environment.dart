import 'dart:isolate';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import '../../eva.dart';
import '../events/event_handler.dart';

@immutable
abstract class Environment {
  const Environment();

  static final _eventHandlers = <String, EventHandler Function(TConcrete Function<TConcrete>() required, PlatformInfo platform)>{};

  void registerDependencies();

  void registerEventHandlers();

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
  void registerEventHandler<T>(EventHandler Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) eventHandlerConstructor) {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    _eventHandlers[T.toString()] = eventHandlerConstructor;
    Log.info(
      () => "Event `Event<${T}>` will be handled by "
          "`${eventHandlerConstructor.toString().replaceFirst("Closure: (<Y0>() => Y0, PlatformInfo) => ", "")}`",
    );
  }

  @protected
  void onMessageReceived(dynamic message) {
    final event = message as Event;
    final eventName = event.runtimeType.toString().replaceFirst("SuccessEvent<", "").replaceFirst("EmptyEvent<", "").replaceFirst("FailureEvent<", "").replaceFirst(">", "");
    final handler = _eventHandlers[eventName];

    if (handler == null) {
      Log.warn(() => "Domain received event `${event.runtimeType}` (${eventName}), but no handler was registered to process it");
      Log.verbose(() => event.toString());
      return;
    }

    Log.debug(() => "Domain received event `${event.runtimeType}`");
    Log.verbose(() => event.toString());

    try {
      // ignore: invalid_use_of_protected_member
      handler(ServiceProvider.required, PlatformInfo.platformInfo).handle(event).forEach((event) => Domain.emit(event));
    } catch (ex) {
      Log.error(() => "Event `${event.runtimeType}` threw `${ex.runtimeType}`");
      Log.verbose(() => ex.toString());
      Log.verbose(() => event.toString());
    }
  }
}
