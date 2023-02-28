import 'package:flutter/material.dart';

import '../../eva/eva.dart';
import '../domain/entities/to_do_theme.dart';

import 'events/load_theme.dart';
import 'home/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return QueryEventBuilder<LoadTheme, ToDoTheme>(
      query: const LoadTheme(),
      otherwiseBuilder: (context, event) => _buildApp(context, WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
      successBuilder: (context, event) => _buildApp(context, event.value.isDarkTheme),
    );
  }

  Widget _buildApp(BuildContext context, bool isDarkTheme) {
    const themeColor = Colors.teal;

    return MaterialApp(
      color: themeColor,
      darkTheme: ThemeData(primarySwatch: themeColor, brightness: Brightness.dark, useMaterial3: true),
      theme: ThemeData(primarySwatch: themeColor, brightness: Brightness.light, useMaterial3: true),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      title: "EvA To Do Example",
      home: const HomePage(),
    );
  }
}
