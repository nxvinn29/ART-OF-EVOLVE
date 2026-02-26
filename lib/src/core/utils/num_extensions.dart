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
}
