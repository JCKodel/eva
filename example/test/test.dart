import 'package:flutter_test/flutter_test.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import 'test_environment.dart';

const env = TestEnvironment();

void main() {
  setUpAll(_setUpTests);
  group("Domain Tests", _domainTests);
}

Future<void> _setUpTests() async {
  env.registerDependencies();
  // ignore: invalid_use_of_protected_member
  await env.initialize(ServiceProvider.required, PlatformInfo.platformInfo);
}

void _domainTests() {}
