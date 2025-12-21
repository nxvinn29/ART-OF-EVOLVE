/// A service that provides motivational quotes.
class QuoteService {
  static final List<String> _quotes = [
    'The only way to do great work is to love what you do. – Steve Jobs',
    'Believe you can and you\'re halfway there. – Theodore Roosevelt',
    'Your time is limited, don\'t waste it living someone else\'s life. – Steve Jobs',
    'Don\'t watch the clock; do what it does. Keep going. – Sam Levenson',
    'The future belongs to those who believe in the beauty of their dreams. – Eleanor Roosevelt',
    'It does not matter how slowly you go as long as you do not stop. – Confucius',
    'Everything you’ve ever wanted is on the other side of fear. – George Addair',
    'Success is not final, failure is not fatal: It is the courage to continue that counts. – Winston Churchill',
  ];

  /// Returns a random quote from the collection.
  static String getRandomQuote() {
    return (_quotes..shuffle()).first;
  }
}
