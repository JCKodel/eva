import 'package:flutter/material.dart';

import 'package:eva/eva.dart';
import '../commands/load_theme_command.dart';
import '../entities/to_do_theme_entity.dart';

import 'home/home_page.dart';

/// STEP#10
/// This is the main app.
class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// A `CommandEventBuilder<A, B>` will:
    ///
    /// 1) Dispatch the `A` command specified by `command`.
    ///
    /// 2) Listen to any `B` event.
    ///
    /// 3) Run onSuccess, onEmpty, onWaiting, onFailure or onOtherwise (if the previous didn't match) -
    ///    These methods return void and are meant to, for example, show an alert or snackbar.
    ///
    /// 4) Run successBuilder, emptyBuilder, waitingBuilder, failureBuilder or otherwiseBuilder (if the previous didn't match)
    ///    There are defaults of every method (except success): empty will render a `SizedBox`, failure will
    ///    render a red screen of death, waiting will render a `CircularProgressIndicator`.
    ///
    ///    You can override those defaults by changing `EventBuilder.defaultEmptyBuilder`,
    ///    `EventBuilder.defaultWaitingBuilder` or `EventBuilder.defaultFailureBuilder`.
    ///
    ///    Do NOT run anything except functions that returns a widget in a build method (this
    ///    is really required for all Flutter, not only EvA)
    return CommandEventBuilder<LoadThemeCommand, ToDoThemeEntity>(
      command: const LoadThemeCommand(),
      // Not sure if this should be handled here, but, while waiting for the
      // theme to load, just shows it using the current device theme brightness
      //
      // Here is a good point to hide the splash screen if you are using the
      //flutter_native_splash package, in `onOtherwise: (_, _)  => FlutterNativeSplash.remove()`
      otherwiseBuilder: (context, event) => _ToDoApp(isDarkTheme: WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
      successBuilder: (context, event) => _ToDoApp(isDarkTheme: event.value.isDarkTheme),
    );
  }
}

/// Just a DRY for the actual app, since we have two separate paths on the code above
///
/// Notice that since Flutter is capable of calling platform code inside isolates
/// since 3.7, you should make all your calls to the platform channels in the domain
/// thread. We're not using any here, so...
///
/// Platform channels are packages that have native code (Java, Kotlin, Swift, Objective-C, etc.)
class _ToDoApp extends StatelessWidget {
  const _ToDoApp({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.blue;

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
