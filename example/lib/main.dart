import 'package:eva/eva.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/environments/development_environment.dart';
import 'app/environments/production_environment.dart';
import 'app/presentation/to_do_app.dart';
import 'app/repositories/isar/isar_app_settings_repository.dart';

Future<void> main() async {
  // This is a hack so the Isar database shows the inspector URL
  // Associated bug report: https://github.com/isar/isar/issues/1134
  if (kDebugMode) {
    await IsarAppSettingsRepository().initialize();
  }

  // STEP#1:
  // We pick an environment based on the current debug/release mode
  // and ask Eva to use it (check any of the classes below to
  // see what they do. In this example, they are the same,
  // except for the minLogLevel.
  //
  // Sometimes, the only difference between development and
  // production is an URL (so each class can have a
  // `String get serverUrl;` so each environment can determine
  // to which API to point).
  //
  // You can have as many environments as you want, such as test,
  // development, homologation, production, beta, etc.
  await Eva.useEnvironment(() => kDebugMode ? const DevelopmentEnvironment() : const ProductionEnvironment());

  // That's it. Eva requires only the one line of code above.
  runApp(const ToDoApp());
}