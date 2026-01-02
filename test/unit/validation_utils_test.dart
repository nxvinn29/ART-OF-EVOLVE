import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/validation_utils.dart';

/// Unit tests for [ValidationUtils].
///
/// Tests email, password, and username validation logic.
void main() {
  group('ValidationUtils Tests', () {
    group('isValidEmail', () {
      test('returns true for valid email addresses', () {
        expect(ValidationUtils.isValidEmail('test@example.com'), true);
        expect(ValidationUtils.isValidEmail('user.name@domain.com'), true);
        expect(ValidationUtils.isValidEmail('test123@test.org'), true);
        expect(ValidationUtils.isValidEmail('a@b.c'), true);
      });

      test('returns false for invalid email addresses', () {
        expect(ValidationUtils.isValidEmail(''), false);
        expect(ValidationUtils.isValidEmail('notanemail'), false);
        expect(ValidationUtils.isValidEmail('@example.com'), false);
        expect(ValidationUtils.isValidEmail('test@'), false);
        expect(ValidationUtils.isValidEmail('test@.com'), false);
        expect(ValidationUtils.isValidEmail('test.example.com'), false);
      });

      test('returns false for emails with spaces', () {
        expect(ValidationUtils.isValidEmail('test @example.com'), false);
        expect(ValidationUtils.isValidEmail('test@ example.com'), false);
        expect(ValidationUtils.isValidEmail(' test@example.com'), false);
      });

      test('handles edge cases', () {
        expect(ValidationUtils.isValidEmail('test+tag@example.com'), false);
        expect(
          ValidationUtils.isValidEmail('test@subdomain.example.com'),
          true,
        );
      });
    });

    group('isValidPassword', () {
      test('returns true for passwords with 6 or more characters', () {
        expect(ValidationUtils.isValidPassword('123456'), true);
        expect(ValidationUtils.isValidPassword('password'), true);
        expect(ValidationUtils.isValidPassword('abcdef'), true);
        expect(ValidationUtils.isValidPassword('a1b2c3'), true);
        expect(ValidationUtils.isValidPassword('verylongpassword123'), true);
      });

      test('returns false for passwords with less than 6 characters', () {
        expect(ValidationUtils.isValidPassword(''), false);
        expect(ValidationUtils.isValidPassword('1'), false);
        expect(ValidationUtils.isValidPassword('12'), false);
        expect(ValidationUtils.isValidPassword('123'), false);
        expect(ValidationUtils.isValidPassword('1234'), false);
        expect(ValidationUtils.isValidPassword('12345'), false);
      });

      test('accepts passwords with special characters', () {
        expect(ValidationUtils.isValidPassword('pass@123'), true);
        expect(ValidationUtils.isValidPassword('!@#\$%^'), true);
        expect(ValidationUtils.isValidPassword('p@ssw0rd!'), true);
      });

      test('accepts passwords with spaces', () {
        expect(ValidationUtils.isValidPassword('pass word'), true);
        expect(ValidationUtils.isValidPassword('      '), true);
      });
    });

    group('isValidUsername', () {
      test('returns true for valid usernames', () {
        expect(ValidationUtils.isValidUsername('abc'), true);
        expect(ValidationUtils.isValidUsername('user'), true);
        expect(ValidationUtils.isValidUsername('username123'), true);
        expect(ValidationUtils.isValidUsername('verylongusername'), true);
      });

      test('returns false for empty username', () {
        expect(ValidationUtils.isValidUsername(''), false);
      });

      test('returns false for usernames with less than 3 characters', () {
        expect(ValidationUtils.isValidUsername('a'), false);
        expect(ValidationUtils.isValidUsername('ab'), false);
      });

      test('accepts usernames with exactly 3 characters', () {
        expect(ValidationUtils.isValidUsername('abc'), true);
        expect(ValidationUtils.isValidUsername('123'), true);
        expect(ValidationUtils.isValidUsername('a1b'), true);
      });

      test('accepts usernames with spaces', () {
        expect(ValidationUtils.isValidUsername('a b'), true);
        expect(ValidationUtils.isValidUsername('user name'), true);
        expect(ValidationUtils.isValidUsername('   '), true);
      });

      test('accepts usernames with special characters', () {
        expect(ValidationUtils.isValidUsername('user@123'), true);
        expect(ValidationUtils.isValidUsername('test_user'), true);
        expect(ValidationUtils.isValidUsername('user-name'), true);
      });

      test('handles edge cases', () {
        expect(ValidationUtils.isValidUsername('   abc'), true);
        expect(ValidationUtils.isValidUsername('abc   '), true);
        expect(ValidationUtils.isValidUsername('  a  '), true);
      });
    });

    group('Integration Tests', () {
      test('validates complete user registration data', () {
        const email = 'newuser@example.com';
        const password = 'secure123';
        const username = 'newuser';

        expect(ValidationUtils.isValidEmail(email), true);
        expect(ValidationUtils.isValidPassword(password), true);
        expect(ValidationUtils.isValidUsername(username), true);
      });

      test('rejects invalid registration data', () {
        const email = 'invalid-email';
        const password = '123';
        const username = 'ab';

        expect(ValidationUtils.isValidEmail(email), false);
        expect(ValidationUtils.isValidPassword(password), false);
        expect(ValidationUtils.isValidUsername(username), false);
      });
    });
  });
}
