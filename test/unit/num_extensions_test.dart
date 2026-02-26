import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/num_extensions.dart';

void main() {
  group('NumExtensions', () {
    test('toCurrency should format correctly', () {
      expect(10.toCurrency(), r'$10.00');
      expect(10.5.toCurrency(), r'$10.50');
      expect(10.toCurrency(symbol: '£'), '£10.00');
      expect(1234.567.toCurrency(decimalDigits: 1), r'$1,234.6');
    });
  });
}
