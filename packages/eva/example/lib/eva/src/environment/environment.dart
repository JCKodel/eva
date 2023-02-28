import 'dart:isolate';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:meta/meta.dart';

import '../events/event.dart';
import '../log/log.dart';

@immutable
abstract class Environment {
  const Environment();

  static final _eventHandlers = <Type, void Function(IEvent event)>{};

  void registerDependencies();

  void registerEventHandlers();

  @protected
  void registerDependency<TService>(TService Function(TConcrete Function<TConcrete>() required, PlatformInfo platform) constructor) {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    ServiceProvider.registerOrReplaceSingleton((optional, required, platform) => constructor(required, platform));
    Log.debug(() => "Dependency `${TService}` will be satisfied by `${constructor.toString().split("=> ").last}`");
  }

  @protected
  TService getDependency<TService>() {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    return ServiceProvider.required<TService>();
  }

  @protected
  void registerEventHandler<T>(void Function(Event<T> event) handler) {
    if (Isolate.current.debugName == "main") {
      throw IsolateSpawnException("Environments cannot be executed on the main thread (i.e.: never call an Environment directly from Flutter code)");
    }

    _eventHandlers[T] = (e) => handler(e as Event<T>);
    Log.debug(() => "Event `Event<${T}>` will be handled by `${handler}`");
  }

  @protected
  void onMessageReceived(dynamic message) {
    final event = message as Event;
    final handler = _eventHandlers[event.runtimeType.toString()];

    if (handler == null) {
      Log.warn(() => "Domain received event `${event.runtimeType}`, but no handler was registered to process it");
      Log.verbose(() => event.toString());
      return;
    }

    Log.debug(() => "Domain received event `${event.runtimeType}`");
    Log.verbose(() => event.toString());

    try {
      handler(event);
    } catch (ex) {
      Log.error(() => "Event `${event.runtimeType}` threw `${ex.runtimeType}`");
      Log.verbose(() => ex.toString());
      Log.verbose(() => event.toString());
    }
  }
}
