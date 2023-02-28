import 'package:flutter/material.dart';

import 'home/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

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
