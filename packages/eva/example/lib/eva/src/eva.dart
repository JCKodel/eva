import 'dart:async';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'environment/environment.dart';
import 'events/event.dart';
import 'log/log.dart';

abstract class Eva {
  static late Isolate _isolate;

  static final ReceivePort _domainReceivePort = ReceivePort("domain");
  static final ReceivePort _errorPort = ReceivePort("error");
  static late final SendPort _domainSendPort;
  static final _useEnvironmentCompleter = Completer<void>();

  static final BehaviorSubject<IEvent> _eventBehaviorSubject = BehaviorSubject<IEvent>(
    onListen: () => Log.verbose(() => "A new subject was added to BehaviorSubject"),
    onCancel: () => Log.warn(() => "The BehaviorSubject was cancelled"),
    sync: false,
  );

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
    _eventBehaviorSubject.add(message);
  }

  static void disposeEnvironment() {
    _domainReceivePort.close();
    _errorPort.close();
    _isolate.kill(priority: Isolate.immediate);
    _eventBehaviorSubject.close();
    Log.warn(() => "Environment has being disposed");
  }

  static void emit(IEvent event) {
    Log.debug(() => "Main is emitting `${event.runtimeType.toString()}`");
    Log.verbose(() => event.toString());

    _domainSendPort.send(event);
  }

  static Stream<Event<T>> getEventsStream<T>() {
    return _eventBehaviorSubject.stream.where((event) => event is Event<T>).cast<Event<T>>();
  }
}

abstract class Domain {
  static final _listenerFromMainPort = ReceivePort();
  static late SendPort _sendToMainPort;
  static late Environment _environment;

  static Future<void> _isolateEntryPoint(List<dynamic> args) async {
    _sendToMainPort = args[0] as SendPort;
    _environment = (args[1] as Environment Function())();

    await _environment.initialize();
    _sendToMainPort.send(_listenerFromMainPort.sendPort);
    _environment.registerDependencies();
    _environment.registerEventHandlers();
    Log.info(() => "Domain started as an isolated thread");
    // ignore: invalid_use_of_protected_member
    _listenerFromMainPort.listen(_environment.onMessageReceived);
    dispatchEventState(const EvaReadyEvent());
  }

  @protected
  static void dispatchEventState(Object eventState) {
    Log.debug(() => "Domain is emitting `${eventState}`");
    Log.verbose(() => eventState.toString());

    _sendToMainPort.send(eventState);
  }
}
