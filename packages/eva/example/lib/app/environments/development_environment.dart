import '../../eva/eva.dart';

import 'base_environment.dart';

@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  @override
  Future<void> initialize() async {
    await super.initialize();
    Log.info(() => "`DevelopmentEnvironment` is initializing");
  }
}
