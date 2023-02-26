import 'package:meta/meta.dart';

import '../../../eva/environment/environment.dart';
import '../../../eva/log/log.dart';

@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  @override
  @mustCallSuper
  Future<void> initialize() async {
    await super.initialize();
    Log.info(() => "`BaseEnvironment` is initializing");
  }
}
