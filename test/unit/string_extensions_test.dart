import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize should upper-case the first letter', () {
      expect('hello'.capitalize, 'Hello');
      expect('world'.capitalize, 'World');
      expect(''.capitalize, '');
      expect('A'.capitalize, 'A');
    });

    test('limit should truncate string correctly', () {
      const text = 'Hello World';
      expect(text.limit(5), 'Hello...');
      expect(text.limit(20), 'Hello World');
      expect(''.limit(5), '');
    });

    test('isValidEmail should validate email formats', () {
      expect('test@example.com'.isValidEmail, true);
      expect('invalid-email'.isValidEmail, false);
      expect('user@domain'.isValidEmail, false); // needs extension
      expect('@domain.com'.isValidEmail, false);
    });

    test('removeSpecialCharacters should clean string', () {
      expect('Hello!@#'.removeSpecialCharacters, 'Hello');
      expect('Test 123'.removeSpecialCharacters, 'Test 123');
    });
  });
}
