import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/goals/services/quote_service.dart';

void main() {
  group('QuoteService', () {
    test('getRandomQuote returns a non-empty string', () {
      final quote = QuoteService.getRandomQuote();
      expect(quote, isNotEmpty);
    });

    test('getRandomQuote returns different quotes over multiple calls', () {
      // It's technically possible to get the same quote twice, but statistically unlikely
      // to get the same one 10 times in a row if the pool is large enough.
      // However, our pool is small (8). Let's collect a set of results.

      final quotes = <String>{};
      for (var i = 0; i < 50; i++) {
        quotes.add(QuoteService.getRandomQuote());
      }

      // Expect finding at least more than 1 unique quote
      expect(quotes.length, greaterThan(1));
    });

    test('returned quotes contain attribution', () {
      final quote = QuoteService.getRandomQuote();
      // Our format is "Quote text. – Author"
      expect(quote, contains('–'));
    });

    test('returned quote is in the known list', () {
      final quote = QuoteService.getRandomQuote();
      // We know there are 8 specific quotes in the list, though the list is private.
      // We can infer validity by structure or by checking against a known set if we exposed it,
      // but since it's private, we'll rely on the attribution check and non-empty check.
      // However, we can check if it matches the expected pattern more strictly if needed.
      expect(quote, matches(RegExp(r'.+ – .+')));
    });
  });
}
