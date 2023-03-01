import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../commands/save_theme_command.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EvA To Do"),
        actions: [
          EventBuilder<ToDoTheme>(
            otherwiseBuilder: (context, event) => _buildThemeBrightnessCheckbox(context, WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
            successBuilder: (context, event) => _buildThemeBrightnessCheckbox(context, event.value.isDarkTheme),
          ),
        ],
      ),
      body: const Center(
        child: Text("Hi"),
      ),
    );
  }

  Widget _buildThemeBrightnessCheckbox(BuildContext context, bool isDarkTheme) {
    return Switch.adaptive(
      value: isDarkTheme,
      onChanged: (newValue) => Eva.dispatchCommand(SaveThemeCommand(isDarkTheme: newValue)),
    );
  }
}
