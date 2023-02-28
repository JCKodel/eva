import 'package:flutter/material.dart';

import 'app/environments/development_environment.dart';
import 'app/presentation/to_do_app.dart';
import 'eva/eva.dart';

Future<void> main() async {
  await Eva.useEnvironment(() => const DevelopmentEnvironment());
  runApp(const ToDoApp());
}
