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

    test('isBetween should check range correctly', () {
      expect(5.isBetween(1, 10), true);
      expect(1.isBetween(1, 10), true);
      expect(10.isBetween(1, 10), true);
      expect(0.isBetween(1, 10), false);
      expect(11.isBetween(1, 10), false);
    });

    test('toFileSize should format bytes correctly', () {
      expect(512.toFileSize(), '512.0 B');
      expect(1024.toFileSize(), '1.0 KB');
      expect((1024 * 1024).toFileSize(), '1.0 MB');
      expect(0.toFileSize(), '0 B');
    });

    test('toPercentage should format correctly', () {
      expect(0.5.toPercentage(), '50.0%');
      expect(1.toPercentage(), '100.0%');
      expect(0.1234.toPercentage(decimalDigits: 2), '12.34%');
      expect(0.toPercentage(), '0.0%');
    });

    test('roundTo should round to specified places', () {
      expect(10.556.roundTo(2), 10.56);
      expect(10.554.roundTo(2), 10.55);
      expect(10.5.roundTo(0), 11.0);
      expect(10.4.roundTo(0), 10.0);
    });
  });
}
