import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:isar/isar.dart';

import 'app/environments/development_environment.dart';
import 'app/presentation/to_do_app.dart';
import 'app/repositories/isar/models/app_settings_model.dart';
import 'eva/eva.dart';

Future<void> main() async {
  if (kDebugMode) {
    await Isar.open([AppSettingsModelSchema], inspector: true, name: "AppSettings");
  }

  await Eva.useEnvironment(() => const DevelopmentEnvironment());
  runApp(const ToDoApp());
}
