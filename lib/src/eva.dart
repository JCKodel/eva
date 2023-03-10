import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'commands/command.dart';
import 'environment/environment.dart';
import 'events/event.dart';
import 'log/log.dart';

/// This delegate is a function that returns whatever dependency was
/// injected.
///
/// Example: `required<ISomeInterface>()` will return the concrete class
/// that was injected for `ISomeInterface`
typedef RequiredFactory = TService Function<TService>({String? key});

/// Event Architecture
abstract class Eva {
  static late Isolate _isolate;

  static final ReceivePort _domainReceivePort = ReceivePort("domain");
  static final ReceivePort _errorPort = ReceivePort("error");
  static final _useEnvironmentCompleter = Completer<void>();
  static late final SendPort _domainSendPort;
  static late final bool _useMultithreading;
  static bool get useMultithreading => _useMultithreading;

  static final BehaviorSubject<IEvent> _eventBehaviorSubject = BehaviorSubject<IEvent>();

  /// Initializes an `Environment` to be used with Eva.
  ///
  /// It will spawn the domain isolate, then run the `Environment.registerDependencies` in that
  /// isolate, then run `Environment.initialize` on the domain isolate.
  static Future<void> useEnvironment<T extends Environment>(T Function() environmentFactory, {required bool useMultithreading}) async {
    _useMultithreading = useMultithreading;

    final environment = environmentFactory();

    if (_useMultithreading && environment.allowRunInMainIsolate == false && Isolate.current.debugName != "main") {
      throw IsolateSpawnException("This method can only be called in the main thread");
    }

    Log.minLogLevel = environment.minLogLevel;
    Log.info(() => "Initializing Eva with `${T}`");

    if (_useMultithreading) {
      _errorPort.listen((error) {
        Log.error(() => "Received error from domain thread: ${error}");
        throw error as Object;
      });

      _domainReceivePort.listen(_onMessageReceived);

      _isolate = await Isolate.spawn<List<dynamic>>(
        DomainIsolateController._isolateEntryPoint,
        [_domainReceivePort.sendPort, environmentFactory, RootIsolateToken.instance!],
        paused: false,
        debugName: "domain",
        errorsAreFatal: false,
        onError: _errorPort.sendPort,
      );

      await _useEnvironmentCompleter.future;
    } else {
      await DomainIsolateController._initialize(environment);
    }
  }

  static void _onMessageReceived(dynamic message) {
    if (message is SendPort) {
      _domainSendPort = message;
      return;
    }

    if (message is _ExecuteOnDomainResponseMessage) {
      final executeOnDomainResponseHandler = _executeOnDomainHandlers[message.completerKey];

      if (executeOnDomainResponseHandler == null) {
        throw Exception("Missing domain response message ${message.completerKey}");
      }

      executeOnDomainResponseHandler(message);

      return;
    }

    if (message is IEvent == false) {
      throw UnsupportedError("Eva received a message ${message.runtimeType}");
    }

    if (message is SuccessEvent<EvaReadyEvent>) {
      _useEnvironmentCompleter.complete();
    }

    final event = message as Event;

    Log.debug(() => "Main received event `${event.runtimeType}`");
    _eventBehaviorSubject.add(message);
  }

  /// If you ever needed, you can kill an environment
  ///
  /// This will kill the isolate and close the
  /// event stream immediately
  static void disposeEnvironment() {
    if (_useMultithreading) {
      _domainReceivePort.close();
      _errorPort.close();
      _isolate.kill(priority: Isolate.immediate);
    }

    _eventBehaviorSubject.close();
    Log.warn(() => "Environment has being disposed");
  }

  /// Sends the `command` to the domain isolate, where the
  /// `Command.handle` method will run
  static void dispatchCommand(Command command) {
    Log.debug(() => "Main is emitting `${command.runtimeType}`");
    Log.verbose(() => command.toString());

    if (_useMultithreading) {
      _domainSendPort.send(command);
    } else {
      DomainIsolateController._onMessageReceived(command);
    }
  }

  static final _executeOnDomainHandlers = <String, void Function(_ExecuteOnDomainResponseMessage response)>{};

  /// Executes the static or top-level function `staticHandler`, passing the `input` argument on the domain isolate.
  ///
  /// The `TOutput` output will be then returned whenever that handler terminates. This `Future<TOutput>` will be
  /// completed with the exception thrown by the `staticHandler`, if any
  static Future<TOutput> executeOnDomain<TInput, TOutput>(
    Future<TOutput> Function(RequiredFactory required, PlatformInfo platform, TInput input) staticHandler, [
    TInput? input,
  ]) async {
    if (_useMultithreading == false) {
      // ignore: invalid_use_of_protected_member
      return staticHandler(ServiceProvider.required, PlatformInfo.platformInfo, input as TInput);
    }

    final completer = Completer<TOutput>();
    final responseKey = "${staticHandler}:${staticHandler.hashCode}:${input}:${input == null ? 0 : input.hashCode}";

    Log.debug(() => "Main is delegating ${TOutput} Function(${TInput}) to domain");
    Log.verbose(() => responseKey);

    _executeOnDomainHandlers[responseKey] = (response) {
      if (response.exception != null) {
        completer.completeError(response.exception!);
      } else {
        completer.complete(response.output as TOutput);
      }
    };

    _domainSendPort.send(_ExecuteOnDomainMessage((r, p, i) => staticHandler(r, p, i as TInput), input, responseKey));

    try {
      final result = await completer.future;

      return result;
    } finally {
      _executeOnDomainHandlers.remove(responseKey);
    }
  }

  static final _lastEmmitedEvents = <int, Object>{};

  @protected
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

// This is the domain isolate controller
abstract class DomainIsolateController {
  static final _listenerFromMainPort = ReceivePort();
  static late SendPort _sendToMainPort;
  static late Environment _environment;

  static Future<void> _isolateEntryPoint(List<dynamic> args) async {
    _sendToMainPort = args[0] as SendPort;
    _environment = (args[1] as Environment Function())();

    final rootIsolationToken = args[2] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolationToken);

    Log.minLogLevel = _environment.minLogLevel;
    _sendToMainPort.send(_listenerFromMainPort.sendPort);
    _environment.registerDependencies();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    // ignore: invalid_use_of_protected_member
    await _environment.initialize(ServiceProvider.required, PlatformInfo.platformInfo);
    Log.info(() => "Domain started as an isolated thread");
    _listenerFromMainPort.listen(_onMessageReceived);
    dispatchEvent(const Event.success(EvaReadyEvent()));
  }

  static Future<void> _initialize(Environment environment) async {
    _environment = environment;
    Log.minLogLevel = _environment.minLogLevel;
    _environment.registerDependencies();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    // ignore: invalid_use_of_protected_member
    await _environment.initialize(ServiceProvider.required, PlatformInfo.platformInfo);
    Log.info(() => "Domain started without multithreading support");
    dispatchEvent(const Event.success(EvaReadyEvent()));
  }

  static void _onMessageReceived(dynamic message) {
    if (message is Command) {
      // ignore: invalid_use_of_protected_member
      _environment.onMessageReceived(message);
      return;
    }

    if (message is _ExecuteOnDomainMessage) {
      try {
        message
            // ignore: invalid_use_of_protected_member
            .staticHandler(ServiceProvider.required, PlatformInfo.platformInfo, message.input)
            .then(
              (output) => _sendToMainPort.send(_ExecuteOnDomainResponseMessage(output, message.completerKey, null)),
            )
            .catchError((Object ex) => _ExecuteOnDomainResponseMessage(null, message.completerKey, ex));
      } catch (ex) {
        _sendToMainPort.send(_ExecuteOnDomainResponseMessage(null, message.completerKey, ex));
      }

      return;
    }

    throw UnsupportedError("${message} is not supported on Domain.onMessageReceived");
  }

  static void dispatchEvent(IEvent eventState) {
    Log.debug(() => "Domain is emitting `${eventState.runtimeType}`");
    Log.verbose(() => eventState.toString());

    if (Eva.useMultithreading) {
      _sendToMainPort.send(eventState);
    } else {
      Eva._onMessageReceived(eventState);
    }
  }
}

@immutable
class _ExecuteOnDomainMessage {
  const _ExecuteOnDomainMessage(this.staticHandler, this.input, this.completerKey);

  final Future<dynamic> Function(RequiredFactory required, PlatformInfo platform, dynamic input) staticHandler;
  final dynamic input;
  final String completerKey;
}

@immutable
class _ExecuteOnDomainResponseMessage {
  const _ExecuteOnDomainResponseMessage(this.output, this.completerKey, this.exception);

  final Object? output;
  final String completerKey;
  final Object? exception;
}
