import 'dart:developer' as developer;

/// A simple logging utility ensuring consistent log formatting.
///
/// Wraps [dart:developer.log] to provide static methods for standard logging levels.
class Logger {
  /// Logs a general [message].
  ///
  /// Optionally accepts a [name] for the log source entry.
  static void log(String message, {String name = 'App'}) {
    developer.log(message, name: name);
  }

  /// Logs an error [message].
  ///
  /// Optionally includes the [error] object and [stackTrace].
  /// The log name is set to 'Error'.
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'Error', error: error, stackTrace: stackTrace);
  }

  /// Logs an informational [message].
  ///
  /// The log name is set to 'Info'.
  static void info(String message) {
    developer.log(message, name: 'Info');
  }
}
