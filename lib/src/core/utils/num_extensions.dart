import 'dart:math' as math;
import 'package:intl/intl.dart';

/// Extension methods for [num].
extension NumExtensions on num {
  /// Formats the number as a currency string.
  ///
  /// [symbol] is the currency symbol (default: '$').
  /// [decimalDigits] is the number of decimal places (default: 2).
  String toCurrency({String symbol = r'$', int decimalDigits = 2}) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return format.format(this);
  }

  /// Checks if the number is between [min] and [max] (inclusive).
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Converts bytes to a human-readable file size string.
  String toFileSize() {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (this == 0) ? 0 : (this.toString().length / 3).floor();
    if (i >= suffixes.length) i = suffixes.length - 1;

    double size = this.toDouble();
    int suffixIndex = 0;
    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(1)} ${suffixes[suffixIndex]}';
  }

  /// Formats the number as a percentage string (e.g., 0.5 -> 50.0%).
  ///
  /// [decimalDigits] is the number of decimal places (default: 1).
  String toPercentage({int decimalDigits = 1}) {
    return '${(this * 100).toStringAsFixed(decimalDigits)}%';
  }

  /// Rounds the number to the specified number of [places].
  double roundTo(int places) {
    final mod = math.pow(10, places);
    return (this * mod).round() / mod;
  }

  /// Checks if the number is a prime number.
  ///
  /// Returns false if the number is not an integer, or if it is less than 2.
  bool get isPrime {
    if (this is! int || this < 2) return false;
    final n = this as int;
    for (var i = 2; i <= math.sqrt(n); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  /// Formats the number into a compact string (e.g., 1.2K, 3.5M).
  String toCompactString() {
    return NumberFormat.compact().format(this);
  }
}
