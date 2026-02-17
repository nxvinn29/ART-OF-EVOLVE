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
      expect('test.user+alias@example.com'.isValidEmail, true);
      expect('invalid-email'.isValidEmail, false);
      expect('user@domain'.isValidEmail, false);
      expect('@domain.com'.isValidEmail, false);
      expect('user@'.isValidEmail, false);
    });

    test('removeSpecialCharacters should clean string', () {
      expect('Hello!@#'.removeSpecialCharacters, 'Hello');
      expect('Test 123'.removeSpecialCharacters, 'Test 123');
    });

    test('toTitleCase should capitalize each word', () {
      expect('hello world'.toTitleCase, 'Hello World');
      expect('HELLO WORLD'.toTitleCase, 'HELLO WORLD');
      expect('one two three'.toTitleCase, 'One Two Three');
    });

    test('initials should return first characters', () {
      expect('Hello World'.initials, 'HW');
      expect('John Doe'.initials, 'JD');
      expect('single'.initials, 'S');
      expect(''.initials, '');
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

    test('toCamelCase should convert to camelCase', () {
      expect('hello world'.toCamelCase, 'helloWorld');
      expect('Hello World'.toCamelCase, 'helloWorld');
      expect('hello_world'.toCamelCase, 'helloWorld');
      expect('hello-world'.toCamelCase, 'helloWorld');
      expect('  Multiple   Spaces  '.toCamelCase, 'multipleSpaces');
      expect(''.toCamelCase, '');
    });

    test(
      'toPascalCase should capitalize each word and remove spaces/underscores',
      () {
        expect('hello world'.toPascalCase, equals('HelloWorld'));
        expect('hello_world'.toPascalCase, equals('HelloWorld'));
        expect('hello-world'.toPascalCase, equals('HelloWorld'));
        expect('HelloWorld'.toPascalCase, equals('HelloWorld'));
        expect(''.toPascalCase, equals(''));
      },
    );

    test('isAlphanumeric should detect alphanumeric strings', () {
      expect('abc123'.isAlphanumeric, true);
      expect('ABC'.isAlphanumeric, true);
      expect('123'.isAlphanumeric, true);
      expect('a b c'.isAlphanumeric, false);
      expect('test!'.isAlphanumeric, false);
      expect(''.isAlphanumeric, false);
    });

    test('containsDigit should detect if string has numbers', () {
      expect('abc1def'.containsDigit, true);
      expect('123'.containsDigit, true);
      expect('no digits here'.containsDigit, false);
      expect(''.containsDigit, false);
      expect('!@#\$'.containsDigit, false);
    });

    test('isBlank should detect empty or whitespace only strings', () {
      expect(''.isBlank, true);
      expect('   '.isBlank, true);
      expect('\n\t'.isBlank, true);
      expect('  a  '.isBlank, false);
      expect('hello'.isBlank, false);
    });

    test('removeWhitespace should strip all spaces, tabs, and newlines', () {
      expect('Hello World'.removeWhitespace, 'HelloWorld');
      expect(' a b c '.removeWhitespace, 'abc');
      expect('\t\n'.removeWhitespace, '');
      expect(''.removeWhitespace, '');
    });

    test('containsAny should detect presence of any list item', () {
      const text = 'Hello World';
      expect(text.containsAny(['Hello', 'Foo']), true);
      expect(text.containsAny(['Bar', 'World']), true);
      expect(text.containsAny(['Foo', 'Bar']), false);
      expect(''.containsAny(['A']), false);
    });

    test('isValidUrl should validate URL formats', () {
      expect('https://google.com'.isValidUrl, true);
      expect('http://www.google.com'.isValidUrl, true);
      expect('google.com'.isValidUrl, true);
      expect('http://test.com/path'.isValidUrl, true);
      expect('ftp://invalid.com'.isValidUrl, false);
      expect('not a url'.isValidUrl, false);
    });

    test('repeat should repeat string correct number of times', () {
      expect('a'.repeat(3), 'aaa');
      expect('abc'.repeat(2), 'abcabc');
      expect('hi'.repeat(0), '');
      expect('hi'.repeat(-1), '');
    });

    test('slugify should create URL-friendly strings', () {
      expect('Hello World!'.slugify(), 'hello-world');
      expect('This is Case Sensitive'.slugify(), 'this-is-case-sensitive');
      expect('Special @#\$% Characters!'.slugify(), 'special-characters');
      expect('  spaces   everywhere  '.slugify(), 'spaces-everywhere');
      expect('already-a-slug'.slugify(), 'already-a-slug');
    });

    test('countOccurrences should return correct count', () {
      expect('hello world'.countOccurrences('o'), 2);
      expect('hello'.countOccurrences('l'), 2);
      expect('hello'.countOccurrences('x'), 0);
      expect(''.countOccurrences('a'), 0);
      expect('a'.countOccurrences(''), 0);
    });
  });
}
