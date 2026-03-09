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

    test('isValidHexColor validates hex color strings', () {
      expect(ValidationUtils.isValidHexColor('#FFFFFF'), true);
      expect(ValidationUtils.isValidHexColor('#000'), true);
      expect(ValidationUtils.isValidHexColor('FFFFFF'), true);
      expect(ValidationUtils.isValidHexColor('#12345678'), true); // Alpha
      expect(ValidationUtils.isValidHexColor('#ZZZ'), false); // Invalid chars
      expect(ValidationUtils.isValidHexColor('#12'), false); // Too short
    });

    test('isValidBio validates length correctly', () {
      expect(ValidationUtils.isValidBio('Short bio'), true);
      expect(
        ValidationUtils.isValidBio('A' * 150),
        true,
      ); // Boundary check: 150 chars
      expect(
        ValidationUtils.isValidBio('A' * 151),
        false,
      ); // Boundary check: 151 chars
    });

    test('isValidAge validates range correctly', () {
      expect(ValidationUtils.isValidAge(25), true);
      expect(ValidationUtils.isValidAge(13), true); // Lower boundary
      expect(ValidationUtils.isValidAge(120), true); // Upper boundary
      expect(ValidationUtils.isValidAge(12), false); // Too young
      expect(ValidationUtils.isValidAge(121), false); // Too old
    });

    test('isValidIPAddress validates IPv4 format', () {
      expect(ValidationUtils.isValidIPAddress('127.0.0.1'), true);
      expect(ValidationUtils.isValidIPAddress('192.168.1.1'), true);
      expect(ValidationUtils.isValidIPAddress('255.255.255.255'), true);
      expect(
        ValidationUtils.isValidIPAddress('256.0.0.1'),
        false,
      ); // Out of range
      expect(
        ValidationUtils.isValidIPAddress('1.2.3'),
        false,
      ); // Too few octets
      expect(ValidationUtils.isValidIPAddress('a.b.c.d'), false); // Non-numeric
    });

    test('isValidIPAddressV6 validates IPv6 format', () {
      expect(
        ValidationUtils.isValidIPAddressV6(
          '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
        ),
        true,
      );
      expect(ValidationUtils.isValidIPAddressV6('::1'), true);
      expect(ValidationUtils.isValidIPAddressV6('invalid-ipv6'), false);
    });

    test('isValidStrongPassword validates password strength', () {
      expect(ValidationUtils.isValidStrongPassword('StrongPass123!'), true);
      expect(ValidationUtils.isValidStrongPassword('weak'), false); // Too short
      expect(
        ValidationUtils.isValidStrongPassword('alllowercase1!'),
        false,
      ); // No uppercase
      expect(
        ValidationUtils.isValidStrongPassword('ALLUPPERCASE1!'),
        false,
      ); // No lowercase
      expect(
        ValidationUtils.isValidStrongPassword('NoNumbers!'),
        false,
      ); // No digits
      expect(
        ValidationUtils.isValidStrongPassword('NoSpecialChar1'),
        false,
      ); // No special chars
    });

    test('isValidUuid validates UUID format', () {
      expect(
        ValidationUtils.isValidUuid('123e4567-e89b-12d3-a456-426614174000'),
        true,
      );
      expect(
        ValidationUtils.isValidUuid('00000000-0000-0000-0000-000000000000'),
        true,
      );
      expect(
        ValidationUtils.isValidUuid('123e4567-e89b-12d3-a456-42661417400'),
        false,
      ); // Too short
      expect(ValidationUtils.isValidUuid('invalid-uuid-format'), false);
    });

    test('isValidCreditCard validates using Luhn algorithm', () {
      // Known valid test card (Stripe)
      expect(ValidationUtils.isValidCreditCard('4242 4242 4242 4242'), true);
      expect(ValidationUtils.isValidCreditCard('4242-4242-4242-4242'), true);
      expect(ValidationUtils.isValidCreditCard('4242424242424242'), true);

      expect(
        ValidationUtils.isValidCreditCard('4242 4242 4242 4243'),
        false,
      ); // Invalid check digit
      expect(ValidationUtils.isValidCreditCard(''), false);
      expect(ValidationUtils.isValidCreditCard('abc'), false);
      expect(ValidationUtils.isValidLength('abc', 2, 5), true);
      expect(ValidationUtils.isValidLength('a', 2, 5), false);
    });

    test('isValidIban should validate IBAN format', () {
      expect(ValidationUtils.isValidIban('DE12345678901234567890'), true);
      expect(ValidationUtils.isValidIban('GB12 ABCD 1234 5678 9012 34'), true);
      expect(ValidationUtils.isValidIban('INVALID'), false);
      expect(ValidationUtils.isValidIban(''), false);
    });

    test('isValidBic should validate BIC format', () {
      expect(ValidationUtils.isValidBic('ABCDEFGH'), true);
      expect(ValidationUtils.isValidBic('ABCDEFGH123'), true);
      expect(ValidationUtils.isValidBic('INVALID'), false);
      expect(ValidationUtils.isValidBic(''), false);
    });

    test('isValidLongitude should validate longitude range', () {
      expect(ValidationUtils.isValidLongitude(0.0), true);
      expect(ValidationUtils.isValidLongitude(180.0), true);
      expect(ValidationUtils.isValidLongitude(-180.0), true);
      expect(ValidationUtils.isValidLongitude(180.1), false);
      expect(ValidationUtils.isValidLongitude(-180.1), false);
    });

    test('isValidCreditCardExpiration validates MM/YY format and date', () {
      final now = DateTime.now();
      final futureYear = (now.year % 100) + 1;
      final futureExpiry = '12/${futureYear.toString().padLeft(2, '0')}';
      expect(ValidationUtils.isValidCreditCardExpiration(futureExpiry), true);
      expect(
        ValidationUtils.isValidCreditCardExpiration('13/25'),
        false,
      ); // Invalid month
      expect(
        ValidationUtils.isValidCreditCardExpiration('12/20'),
        false,
      ); // Expired
      expect(ValidationUtils.isValidCreditCardExpiration('abc'), false);
    });

    test('isValidCVV validates 3 or 4 digits', () {
      expect(ValidationUtils.isValidCVV('123'), true);
      expect(ValidationUtils.isValidCVV('1234'), true);
      expect(ValidationUtils.isValidCVV('12'), false);
      expect(ValidationUtils.isValidCVV('12345'), false);
      expect(ValidationUtils.isValidCVV('abc'), false);
    });

    test('isValidTime24h should validate correctly', () {
      expect(ValidationUtils.isValidTime24h('13:45'), true);
      expect(ValidationUtils.isValidTime24h('00:00'), true);
      expect(ValidationUtils.isValidTime24h('23:59'), true);
      expect(ValidationUtils.isValidTime24h('24:00'), false);
      expect(ValidationUtils.isValidTime24h('1:1'), false);
    });

    test('isValidDate should validate format correctly', () {
      expect(ValidationUtils.isValidDate('2024-01-01', 'yyyy-MM-dd'), true);
      expect(ValidationUtils.isValidDate('01/01/2024', 'dd/MM/yyyy'), true);
      expect(ValidationUtils.isValidDate('2024-13-01', 'yyyy-MM-dd'), false);
      expect(ValidationUtils.isValidDate('abc', 'yyyy-MM-dd'), false);
    });

    test('isValidPostalCode validates 5-digit postal codes', () {
      expect(ValidationUtils.isValidPostalCode('12345'), true);
      expect(ValidationUtils.isValidPostalCode('90210'), true);
      expect(ValidationUtils.isValidPostalCode('1234'), false);
      expect(ValidationUtils.isValidPostalCode('123456'), false);
      expect(ValidationUtils.isValidPostalCode('abcde'), false);
    });

    test('isValidIsbn validates ISBN-10 and ISBN-13 correctly', () {
      // ISBN-10
      expect(ValidationUtils.isValidIsbn('0471958697'), true);
      expect(ValidationUtils.isValidIsbn('0-471-95869-7'), true);
      expect(ValidationUtils.isValidIsbn('047195869X'), false); // Invalid
      expect(ValidationUtils.isValidIsbn('080442957X'), true); // Last char X

      // ISBN-13
      expect(ValidationUtils.isValidIsbn('9780470059029'), true);
      expect(ValidationUtils.isValidIsbn('978-0-470-05902-9'), true);
      expect(ValidationUtils.isValidIsbn('9780470059028'), false); // Invalid

      // Edge cases
      expect(ValidationUtils.isValidIsbn(''), false);
      expect(ValidationUtils.isValidIsbn('123456789'), false);
    });

    test('isValidYoutubeUrl validates YouTube URLs', () {
      expect(
        ValidationUtils.isValidYoutubeUrl(
          'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        ),
        true,
      );
      expect(
        ValidationUtils.isValidYoutubeUrl('https://youtu.be/dQw4w9WgXcQ'),
        true,
      );
      expect(
        ValidationUtils.isValidYoutubeUrl(
          'https://www.youtube.com/embed/dQw4w9WgXcQ',
        ),
        true,
      );
      expect(ValidationUtils.isValidYoutubeUrl('invalid'), false);
    });

    test('isValidGithubUrl validates GitHub URLs', () {
      expect(
        ValidationUtils.isValidGithubUrl('https://github.com/flutter'),
        true,
      );
      expect(
        ValidationUtils.isValidGithubUrl('https://github.com/flutter/flutter'),
        true,
      );
      expect(ValidationUtils.isValidGithubUrl('github.com/flutter'), true);
      expect(ValidationUtils.isValidGithubUrl('invalid'), false);
    });
  });
}
