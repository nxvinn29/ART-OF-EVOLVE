import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/validation_utils.dart';

void main() {
  group('ValidationUtils', () {
    test('isValidEmail validates emails correctly', () {
      expect(ValidationUtils.isValidEmail('test@example.com'), true);
      expect(ValidationUtils.isValidEmail('test.user@domain.co.uk'), true);
      expect(ValidationUtils.isValidEmail('invalid-email'), false);
      expect(ValidationUtils.isValidEmail('@domain.com'), false);
    });

    test('isValidPassword requires 8 chars and number', () {
      expect(ValidationUtils.isValidPassword('password123'), true);
      expect(ValidationUtils.isValidPassword('pass1'), false); // Too short
      expect(ValidationUtils.isValidPassword('password'), false); // No number
    });

    test('isValidUsername requires 3 chars', () {
      expect(ValidationUtils.isValidUsername('User'), true);
      expect(ValidationUtils.isValidUsername('Hi'), false);
      expect(ValidationUtils.isValidUsername(''), false);
    });

    test('sanitizeInput removes HTML tags and trims', () {
      expect(ValidationUtils.sanitizeInput('  Hello  '), 'Hello');
      expect(
        ValidationUtils.sanitizeInput('<script>alert("hi")</script>Hello'),
        'Hello',
      );
      expect(ValidationUtils.sanitizeInput('<b>Bold</b> Text'), 'Bold Text');
    });
  });
}
