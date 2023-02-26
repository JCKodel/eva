import 'package:flutter/material.dart';

import 'app/environments/development/development_environment.dart';
import 'eva/eva.dart';
import 'eva/events/eva_ready_event.dart';

Future<void> main() async {
  await Eva.useEnvironment(() => const DevelopmentEnvironment());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Eva.emit(const EvaReadyEvent()),
            child: const Text("SEND TO DOMAIN"),
          ),
        ),
      ),
    );
  }
}
