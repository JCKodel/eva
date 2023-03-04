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
  static DateTime? _lastLogEntry;

  static LogLevel _minLogLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  static LogLevel get minLogLevel => _minLogLevel;

  static set minLogLevel(LogLevel logLevel) {
    _minLogLevel = logLevel;
    Log.info(() => "Log level changed to ${logLevel}");
  }

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
    final now = DateTime.now();

    if (_lastLogEntry != null && now.difference(_lastLogEntry!).inMilliseconds > 999) {
      _lastLogEntry = null;
    }

    final logTime = "${_lastLogEntry == null ? now : "+${now.difference(_lastLogEntry!).inMilliseconds}"}";

    _lastLogEntry = now;

    if (kIsWeb) {
      // ignore: avoid_print
      print(
        "[${levelDescription}] ${header} \x1B[38;5;242m${logTime}${color.ansiString}: ${messageGenerator()}${LogColor.reset.ansiString}\n\n",
      );
    } else {
      log(
        "${header} \x1B[38;5;242m${logTime}${color.ansiString}: ${messageGenerator()}${LogColor.reset.ansiString}\n\n",
        error: error,
        level: color.index,
        name: Isolate.current.debugName ?? "",
        time: DateTime.now(),
      );
    }
  }
}
