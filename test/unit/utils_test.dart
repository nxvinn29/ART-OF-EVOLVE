import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/date_utils.dart';
import 'package:art_of_evolve/src/core/utils/validation_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('isSameDay should return true for same day', () {
      final date1 = DateTime(2025, 12, 25, 10, 0);
      final date2 = DateTime(2025, 12, 25, 22, 0);
      expect(AppDateUtils.isSameDay(date1, date2), true);
    });

    test('isSameDay should return false for different days', () {
      final date1 = DateTime(2025, 12, 25);
      final date2 = DateTime(2025, 12, 26);
      expect(AppDateUtils.isSameDay(date1, date2), false);
    });
  });

  group('ValidationUtils', () {
    test('isValidEmail should validate email correctly', () {
      expect(ValidationUtils.isValidEmail('test@example.com'), true);
      expect(ValidationUtils.isValidEmail('invalid-email'), false);
    });

    test('isValidPassword should require at least 6 chars', () {
      expect(ValidationUtils.isValidPassword('123456'), true);
      expect(ValidationUtils.isValidPassword('12345'), false);
    });

    test('isValidUsername should require at least 3 chars', () {
      expect(ValidationUtils.isValidUsername('ABC'), true);
      expect(ValidationUtils.isValidUsername('AB'), false);
    });
  });
}
