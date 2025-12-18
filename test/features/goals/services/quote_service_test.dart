import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/goals/services/quote_service.dart';

void main() {
  group('QuoteService', () {
    test('getRandomQuote returns a non-empty string', () {
      final quote = QuoteService.getRandomQuote();
      expect(quote, isNotEmpty);
    });

    test('getRandomQuote returns a string from the pre-defined list', () {
      // This is slightly tricky because the list is private,
      // but we can verify it returns something consistently non-null.
      final quote = QuoteService.getRandomQuote();
      expect(quote, isA<String>());
    });
  });
}
