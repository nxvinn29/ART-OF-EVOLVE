import 'dart:developer' as developer;

class Logger {
  static void log(String message, {String name = 'App'}) {
    developer.log(message, name: name);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'Error', error: error, stackTrace: stackTrace);
  }

  static void info(String message) {
    developer.log(message, name: 'Info');
  }
}
