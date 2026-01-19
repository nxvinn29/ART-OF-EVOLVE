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
      expect(ValidationUtils.isValidUsername('Bob'), true); // Boundary check
      expect(ValidationUtils.isValidUsername('Hi'), false);
      expect(ValidationUtils.isValidUsername(''), false);
    });

    test('sanitizeInput removes HTML tags and trims', () {
      expect(ValidationUtils.sanitizeInput('  Hello  '), 'Hello');
      expect(ValidationUtils.sanitizeInput('<div>Hello</div>'), 'Hello');
      expect(ValidationUtils.sanitizeInput('<b>Bold</b> Text'), 'Bold Text');
      expect(
        ValidationUtils.sanitizeInput('<div></div>'),
        '',
      ); // Empty after removal
      expect(ValidationUtils.sanitizeInput('No Tags'), 'No Tags');
    });

    test('isValidPhoneNumber validates 10-digit numbers', () {
      expect(ValidationUtils.isValidPhoneNumber('1234567890'), true);
      expect(ValidationUtils.isValidPhoneNumber('9876543210'), true);
      expect(ValidationUtils.isValidPhoneNumber('123'), false); // Too short
      expect(
        ValidationUtils.isValidPhoneNumber('12345678901'),
        false,
      ); // Too long
      expect(
        ValidationUtils.isValidPhoneNumber('abcdefghij'),
        false,
      ); // Non-digit
    });

    test('isValidUrl validates URLs correctly', () {
      expect(ValidationUtils.isValidUrl('https://example.com'), true);
      expect(ValidationUtils.isValidUrl('http://test.org/path'), true);
      expect(
        ValidationUtils.isValidUrl('example.com'),
        false,
      ); // missing scheme
      expect(ValidationUtils.isValidUrl(''), false);
    });

    test('isValidName validates names correctly', () {
      expect(ValidationUtils.isValidName('John Doe'), true);
      expect(ValidationUtils.isValidName('Alice'), true);
      expect(ValidationUtils.isValidName('Jo'), true);
      expect(ValidationUtils.isValidName('A'), false); // Too short
      expect(ValidationUtils.isValidName('123'), false); // Numbers
    });

    test('isValidZipCode validates US zip codes', () {
      expect(ValidationUtils.isValidZipCode('12345'), true);
      expect(ValidationUtils.isValidZipCode('90210'), true);
      expect(ValidationUtils.isValidZipCode('1234'), false); // Too short
      expect(ValidationUtils.isValidZipCode('123456'), false); // Too long
      expect(ValidationUtils.isValidZipCode('abcde'), false); // Non-digit
    });
  });
}
