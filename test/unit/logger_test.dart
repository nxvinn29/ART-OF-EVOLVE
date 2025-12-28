import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/logger.dart';

void main() {
  group('Logger Tests', () {
    test('should act as a smoke test for logging methods', () {
      // Since Logger uses dart:developer.log which returns void and has side effects
      // primarily visible in debug consoles, we mainly ensure these methods
      // can be called without runtime errors.

      expect(() => Logger.log('Test message'), returnsNormally);
      expect(() => Logger.info('Info message'), returnsNormally);
      expect(() => Logger.warning('Warning message'), returnsNormally);
      expect(
        () => Logger.error('Error message', error: Exception('test')),
        returnsNormally,
      );
    });
  });
}
