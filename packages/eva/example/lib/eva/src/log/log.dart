import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

enum LogLevel {
  error,
  warn,
  info,
  debug,
  verbose,
}

enum LogColor {
  reset("\x1B[0m"),
  black("\x1B[30m"),
  red("\x1B[31m"),
  green("\x1B[32m"),
  yellow("\x1B[33m"),
  blue("\x1B[34m"),
  magenta("\x1B[35m"),
  cyan("\x1B[36m"),
  white("\x1B[37m");

  const LogColor(this.ansiString);

  final String ansiString;
}

abstract class Log {
  static LogLevel minLogLevel = kDebugMode ? LogLevel.verbose : LogLevel.info;

  static void verbose(String Function() messageGenerator) {
    if (kDebugMode) {
      if (minLogLevel.index >= LogLevel.verbose.index) {
        _log(LogLevel.verbose, LogColor.magenta, "🟣", messageGenerator);
      }
    }
  }

  static void debug(String Function() messageGenerator) {
    if (kDebugMode) {
      if (minLogLevel.index >= LogLevel.debug.index) {
        _log(LogLevel.debug, LogColor.white, "⚪️", messageGenerator);
      }
    }
  }

  static void info(String Function() messageGenerator) {
    if (minLogLevel.index >= LogLevel.info.index) {
      _log(LogLevel.info, LogColor.blue, "🔵", messageGenerator);
    }
  }

  static void warn(String Function() messageGenerator, [Object? error]) {
    if (minLogLevel.index >= LogLevel.warn.index) {
      _log(LogLevel.warn, LogColor.yellow, "🟠", messageGenerator, error);
    }
  }

  static void error(String Function() messageGenerator, [Object? error]) {
    _log(LogLevel.error, LogColor.red, "🔴", messageGenerator, error);
  }

  static void _log(LogLevel level, LogColor color, String header, String Function() messageGenerator, [Object? error]) {
    final levelDescription = level.toString().substring("LogLevel.".length);

    if (kIsWeb) {
      // ignore: avoid_print
      print(
        "[${levelDescription}] ${header} ${color.ansiString}: ${messageGenerator()}${LogColor.reset.ansiString}",
      );
    } else {
      log(
        "${header} ${color.ansiString}${messageGenerator()}${LogColor.reset.ansiString}",
        error: error,
        level: color.index,
        name: Isolate.current.debugName ?? "",
        time: DateTime.now(),
      );
    }
  }
}
