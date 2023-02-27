import 'package:flutter/material.dart';

import 'app/environments/development_environment.dart';
import 'app/presentation/home/home_page.dart';
import 'eva/eva.dart';

Future<void> main() async {
  await Eva.useEnvironment(() => const DevelopmentEnvironment());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.teal,
      darkTheme: ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      theme: ThemeData(primarySwatch: Colors.teal, brightness: Brightness.light),
      themeMode: ThemeMode.system,
      title: "EvA To Do Example",
      home: const HomePage(),
    );
  }
}
