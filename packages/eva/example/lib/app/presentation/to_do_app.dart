import 'package:flutter/material.dart';

import '../../eva/eva.dart';
import '../domain/entities/to_do_theme.dart';

import 'events/theme_events.dart';
import 'home/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EventBuilder<ToDoTheme>(
      initialEvent: ToDoTheme(
        isDarkTheme: WidgetsBinding.instance.window.platformBrightness == Brightness.dark,
      ),
      emitOnLoad: () => const LoadThemeEvent(),
      successBuilder: (context, event, value) {
        const themeColor = Colors.teal;
        final themeMode = value.isDarkTheme ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp(
          color: themeColor,
          darkTheme: ThemeData(primarySwatch: themeColor, brightness: Brightness.dark),
          theme: ThemeData(primarySwatch: themeColor, brightness: Brightness.light),
          themeMode: themeMode,
          title: "EvA To Do Example",
          home: const HomePage(),
        );
      },
    );
  }
}
