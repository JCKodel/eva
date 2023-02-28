import 'package:flutter/material.dart';

import '../../eva/eva.dart';
import '../domain/entities/to_do_theme.dart';

import 'home/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EventBuilder<ToDoTheme>(
      initialValue: ToDoTheme(isDarkTheme: WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
      successBuilder: (context, event) {
        const themeColor = Colors.teal;

        return MaterialApp(
          color: themeColor,
          darkTheme: ThemeData(primarySwatch: themeColor, brightness: Brightness.dark),
          theme: ThemeData(primarySwatch: themeColor, brightness: Brightness.light),
          themeMode: event.value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          title: "EvA To Do Example",
          home: const HomePage(),
        );
      },
    );
  }
}
