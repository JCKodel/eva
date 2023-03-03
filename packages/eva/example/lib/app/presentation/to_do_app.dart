import 'package:flutter/material.dart';

import '../../eva/eva.dart';
import '../commands/load_theme_command.dart';
import '../entities/to_do_theme_entity.dart';

import 'home/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CommandEventBuilder<LoadThemeCommand, ToDoThemeEntity>(
      command: const LoadThemeCommand(),
      otherwiseBuilder: (context, event) => _ToDoApp(isDarkTheme: WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
      successBuilder: (context, event) => _ToDoApp(isDarkTheme: event.value.isDarkTheme),
    );
  }
}

class _ToDoApp extends StatelessWidget {
  const _ToDoApp({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.teal;

    return MaterialApp(
      color: themeColor,
      darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: themeColor, brightness: Brightness.dark),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: themeColor, brightness: Brightness.light),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      title: "EvA To Do Example",
      home: const HomePage(),
    );
  }
}
