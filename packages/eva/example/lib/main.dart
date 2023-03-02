import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/environments/development_environment.dart';
import 'app/presentation/to_do_app.dart';
import 'app/repositories/isar/isar_app_settings_repository.dart';
import 'eva/eva.dart';

Future<void> main() async {
  if (kDebugMode) {
    IsarAppSettingsRepository().initialize();
  }

  await Eva.useEnvironment(() => const DevelopmentEnvironment());
  runApp(const ToDoApp());
}
