import 'dart:async';
import 'dart:isolate';

import 'environment/environment.dart';
import 'events/eva_ready_event.dart';
import 'events/event.dart';
import 'log/log.dart';

abstract class Eva {
  static late Isolate _isolate;

  static final ReceivePort _domainReceivePort = ReceivePort("domain");
  static final ReceivePort _errorPort = ReceivePort("error");
  static late final SendPort _domainSendPort;
  static final _useEnvironmentCompleter = Completer<void>();

  static Future<void> useEnvironment<T extends Environment>(T Function() environmentFactory) async {
    if (Isolate.current.debugName != "main") {
      throw IsolateSpawnException("This method can only be called in the main thread");
    }

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

    await _useEnvironmentCompleter.future.timeout(const Duration(seconds: 1));
  }

  static void _onMessageReceived(dynamic message) {
    if (message is SendPort) {
      _domainSendPort = message;
      _useEnvironmentCompleter.complete();
      return;
    }

    final event = message as Event;

    Log.debug(() => "Main received event `${event.runtimeType}`");
    Log.verbose(() => event.toString());
  }

  static void disposeEnvironment() {
    _domainReceivePort.close();
    _errorPort.close();
    _isolate.kill(priority: Isolate.immediate);
    Log.warn(() => "Environment has being disposed");
  }

  static void emit(Event event) {
    Log.debug(() => "Main is emitting `${event.runtimeType}`");
    Log.verbose(() => event.toString());

    _domainSendPort.send(event);
  }
}

abstract class Domain {
  static final _listenerFromMainPort = ReceivePort();
  static late SendPort _sendToMainPort;
  static late Environment _environment;

  static Future<void> _isolateEntryPoint(List<dynamic> args) async {
    _sendToMainPort = args[0] as SendPort;
    _environment = (args[1] as Environment Function())();
    _listenerFromMainPort.listen(_onMessageReceived);
    Log.info(() => "Domain started as an isolated thread");
    _sendToMainPort.send(_listenerFromMainPort.sendPort);
    await _environment.initialize();
    emit(const EvaReadyEvent());
  }

  static void emit(Event event) {
    Log.debug(() => "Domain is emitting `${event.runtimeType}`");
    Log.verbose(() => event.toString());

    _sendToMainPort.send(event);
  }

  static void _onMessageReceived(dynamic message) {
    final event = message as Event;

    Log.debug(() => "Domain received event `${event.runtimeType}`");
    Log.verbose(() => event.toString());
  }
}
