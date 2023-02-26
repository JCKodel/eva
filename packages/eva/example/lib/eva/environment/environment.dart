import 'dart:isolate';

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
}
