import 'package:meta/meta.dart';

import 'src/environments/environment.dart';

@immutable
class _Eva {
  const _Eva();

  void useEnvironment(Environment environment) {}
}

const eva = _Eva();
