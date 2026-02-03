import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/exceptions/app_exception.dart';

void main() {
  group('AppException', () {
    test('NetworkException stores message and code correctly', () {
      const exception = NetworkException('No internet', code: '404');

      expect(exception.message, 'No internet');
      expect(exception.code, '404');
      expect(exception.toString(), 'AppException: No internet (code: 404)');
    });

    test('DatabaseException handles details', () {
      const exception = DatabaseException(
        'Read error',
        details: {'table': 'users'},
      );

      expect(exception.message, 'Read error');
      expect(exception.details, isMap);
      expect(exception.details['table'], 'users');
    });

    test('ValidationException supports custom codes', () {
      const exception = ValidationException(
        'Invalid email',
        code: 'INVALID_FORMAT',
      );

      expect(exception.message, 'Invalid email');
      expect(exception.code, 'INVALID_FORMAT');
    });

    test('Exceptions are distinct types', () {
      const net = NetworkException('msg');
      const db = DatabaseException('msg');

      expect(net, isA<AppException>());
      expect(db, isA<AppException>());
      expect(net, isNot(isA<DatabaseException>()));
    });

    test('UnauthorizedException stores details correctly', () {
      const exception = UnauthorizedException(
        'User not logged in',
        code: 'AUTH_REQUIRED',
      );

      expect(exception.message, 'User not logged in');
      expect(exception.code, 'AUTH_REQUIRED');
      expect(exception, isA<AppException>());
    });

    test('TimeoutException stores message correctly', () {
      const exception = TimeoutException('Operation timed out');
      expect(exception.message, 'Operation timed out');
      expect(exception, isA<AppException>());
    });
  });
}
