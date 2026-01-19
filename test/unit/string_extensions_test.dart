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

    test('toTitleCase should capitalize each word', () {
      expect('hello world'.toTitleCase, 'Hello World');
      expect(
        'HELLO WORLD'.toTitleCase,
        'HELLO WORLD',
      ); // capitalize implementation preserves subsequent UPPERCASE if only first char changed?
      // Wait, capitalize uses substring(1). If first char is upper, it stays.
      // But if input is 'hELLO', it becomes 'HELLO'.
      // If input is 'HELLO', it stays 'HELLO'.
      // So 'HELLO WORLD' -> 'HELLO WORLD'.
      expect('one two three'.toTitleCase, 'One Two Three');
    });

    test('initials should return first characters', () {
      expect('Hello World'.initials, 'HW');
      expect('John Doe'.initials, 'JD');
      expect('single'.initials, 'S');
      expect(''.initials, '');

      // My implementation had where((w) => w.isNotEmpty).
      // So '   Spaces   ' -> ['Spaces'] -> 'S'.
      expect('   Spaces   '.initials, 'S');
      expect('First Second Third'.initials, 'FS');
    });

    test('wordCount should return correct number of words', () {
      expect('Hello World'.wordCount, 2);
      expect('One   Two'.wordCount, 2);
      expect(''.wordCount, 0);
      expect('   '.wordCount, 0);
    });

    test('isNumeric should detect numbers', () {
      expect('123'.isNumeric, true);
      expect('12.34'.isNumeric, true);
      expect('-5'.isNumeric, true);
      expect('abc'.isNumeric, false);
      expect('12a'.isNumeric, false);
    });

    test('reverse should reverse string', () {
      expect('abc'.reverse, 'cba');
      expect('Hello'.reverse, 'olleH');
      expect(''.reverse, '');
    });

    test('truncate should strictly cut string with optional suffix', () {
      expect('Hello World'.truncate(5), 'Hello');
      expect('Hello World'.truncate(5, suffix: '...'), 'Hello...');
      expect('Hello'.truncate(10), 'Hello');
      expect(''.truncate(5), '');
    });

    test('toKebabCase should convert to kebab-case', () {
      expect('Hello World'.toKebabCase, 'hello-world');
      expect('helloWorld'.toKebabCase, 'hello-world');
      expect('Hello_World'.toKebabCase, 'hello-world');
      expect('  Hello  World  '.toKebabCase, 'hello-world');
    });

    test('toSnakeCase should convert to snake_case', () {
      expect('Hello World'.toSnakeCase, 'hello_world');
      expect('helloWorld'.toSnakeCase, 'hello_world');
      expect('Hello-World'.toSnakeCase, 'hello_world');
      expect('  Hello  World  '.toSnakeCase, 'hello_world');
    });
  });
}
