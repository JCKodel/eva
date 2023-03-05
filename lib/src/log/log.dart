import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

/// Log levels
enum LogLevel {
  /// Errors and exceptions
  error,

  /// Non-fatal errors
  warn,

  /// General information
  info,

  /// Useful debug info
  debug,

  /// Verbose detailed logs
  verbose,
}

/// ANSI colors to use in logs
enum LogColor {
  /// Default color
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

/// A simple Dart logger
abstract class Log {
  static DateTime? _lastLogEntry;

  static LogLevel _minLogLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  /// The minimum level to show (order: verbose > debug > info > warn > error)
  static LogLevel get minLogLevel => _minLogLevel;

  static set minLogLevel(LogLevel logLevel) {
    _minLogLevel = logLevel;
    Log.info(() => "Log level changed to ${logLevel}");
  }

  /// Logs a verbose message, if `minLogLevel` allows it
  ///
  /// Since the message is a closure that returns a String, this
  /// message will never be built if the current log level doesn't
  /// allow this level of log
  ///
  /// Verbose logs are never executed in release builds, no matter the `minLogLevel`
  static void verbose(String Function() messageGenerator) {
    if (kDebugMode) {
      if (minLogLevel.index >= LogLevel.verbose.index) {
        _log(LogLevel.verbose, LogColor.magenta, "🟣", messageGenerator);
      }
    }
  }

  /// Logs a debug message, if `minLogLevel` allows it
  ///
  /// Since the message is a closure that returns a String, this
  /// message will never be built if the current log level doesn't
  /// allow this level of log
  ///
  /// Debug logs are never executed in release builds, no matter the `minLogLevel`
  static void debug(String Function() messageGenerator) {
    if (kDebugMode) {
      if (minLogLevel.index >= LogLevel.debug.index) {
        _log(LogLevel.debug, LogColor.white, "⚪️", messageGenerator);
      }
    }
  }

  /// Logs an informational message, if `minLogLevel` allows it
  ///
  /// Since the message is a closure that returns a String, this
  /// message will never be built if the current log level doesn't
  /// allow this level of log
  static void info(String Function() messageGenerator) {
    if (minLogLevel.index >= LogLevel.info.index) {
      _log(LogLevel.info, LogColor.blue, "🔵", messageGenerator);
    }
  }

  /// Logs a warning message, if `minLogLevel` allows it
  ///
  /// Since the message is a closure that returns a String, this
  /// message will never be built if the current log level doesn't
  /// allow this level of log
  static void warn(String Function() messageGenerator, [Object? error]) {
    if (minLogLevel.index >= LogLevel.warn.index) {
      _log(LogLevel.warn, LogColor.yellow, "🟠", messageGenerator, error);
    }
  }

  /// Logs an error message, if `minLogLevel` allows it
  ///
  /// Since the message is a closure that returns a String, this
  /// message will never be built if the current log level doesn't
  /// allow this level of log
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
