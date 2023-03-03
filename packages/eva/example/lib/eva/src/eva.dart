import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:rxdart/rxdart.dart';

import 'commands/command.dart';
import 'environment/environment.dart';
import 'events/event.dart';
import 'log/log.dart';

abstract class Eva {
  static late Isolate _isolate;

  static final ReceivePort _domainReceivePort = ReceivePort("domain");
  static final ReceivePort _errorPort = ReceivePort("error");
  static late final SendPort _domainSendPort;
  static final _useEnvironmentCompleter = Completer<void>();

  static final BehaviorSubject<IEvent> _eventBehaviorSubject = BehaviorSubject<IEvent>();

  static Future<void> useEnvironment<T extends Environment>(T Function() environmentFactory) async {
    if (Isolate.current.debugName != "main") {
      throw IsolateSpawnException("This method can only be called in the main thread");
    }

    final environment = environmentFactory();

    Log.minLogLevel = environment.minLogLevel;
    Log.info(() => "Initializing Eva with `${T}`");

    _errorPort.listen((error) {
      Log.error(() => "Received error from domain thread: ${error}");
      throw error as Object;
    });

    _domainReceivePort.listen(_onMessageReceived);

    _isolate = await Isolate.spawn<List<dynamic>>(
      Domain._isolateEntryPoint,
      [_domainReceivePort.sendPort, environmentFactory],
      paused: false,
      debugName: "domain",
      errorsAreFatal: false,
      onError: _errorPort.sendPort,
    );

    await _useEnvironmentCompleter.future;
  }

  static void _onMessageReceived(dynamic message) {
    if (message is SendPort) {
      _domainSendPort = message;
      return;
    }

    if (message is SuccessEvent<EvaReadyEvent>) {
      _useEnvironmentCompleter.complete();
    }

    final event = message as Event;

    Log.debug(() => "Main received event `${event.runtimeType}`");
    _eventBehaviorSubject.add(message);
  }

  static void disposeEnvironment() {
    _domainReceivePort.close();
    _errorPort.close();
    _isolate.kill(priority: Isolate.immediate);
    _eventBehaviorSubject.close();
    Log.warn(() => "Environment has being disposed");
  }

  static void dispatchCommand(Command command) {
    Log.debug(() => "Main is emitting `${command.runtimeType}`");
    Log.verbose(() => command.toString());

    _domainSendPort.send(command);
  }

  static final Map<int, Object> _lastEmmitedEvents = <int, Object>{};

  static Stream<Event<T>> getEventsStream<T>(int consumer) {
    return _eventBehaviorSubject.stream.where((event) {
      if (event is Event<T> == false) {
        return false;
      }

      if (event is SuccessEvent<T> == false) {
        return true;
      }

      final value = (event as SuccessEvent<T>).value;
      final lastEmmitedValue = _lastEmmitedEvents[consumer];

      _lastEmmitedEvents[consumer] = value as Object;

      if (lastEmmitedValue == null) {
        return true;
      }

      return value != lastEmmitedValue;
    }).cast<Event<T>>();
  }
}

abstract class Domain {
  static final _listenerFromMainPort = ReceivePort();
  static late SendPort _sendToMainPort;
  static late Environment _environment;

  static Future<void> _isolateEntryPoint(List<dynamic> args) async {
    _sendToMainPort = args[0] as SendPort;
    _environment = (args[1] as Environment Function())();
    Log.minLogLevel = _environment.minLogLevel;
    _sendToMainPort.send(_listenerFromMainPort.sendPort);
    _environment.registerDependencies();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    // ignore: invalid_use_of_protected_member
    await _environment.initialize(ServiceProvider.required, PlatformInfo.platformInfo);
    Log.info(() => "Domain started as an isolated thread");
    // ignore: invalid_use_of_protected_member
    _listenerFromMainPort.listen(_environment.onMessageReceived);
    dispatchEvent(const Event.success(EvaReadyEvent()));
  }

  @protected
  static void dispatchEvent(IEvent eventState) {
    Log.debug(() => "Domain is emitting `${eventState.runtimeType}`");
    Log.verbose(() => eventState.toString());

    _sendToMainPort.send(eventState);
  }
}
