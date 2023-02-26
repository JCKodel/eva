import 'package:meta/meta.dart';

import '../../../eva/log/log.dart';
import '../shared/base_environment.dart';

@immutable
class DevelopmentEnvironment extends BaseEnvironment {
  const DevelopmentEnvironment();

  @override
  Future<void> initialize() async {
    await super.initialize();
    Log.info(() => "`DevelopmentEnvironment` is initializing");
  }
}
