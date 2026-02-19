import 'dart:convert';

/// String utility extensions for the Art of Evolve project.
///
/// This file provides common string manipulation methods such as capitalization,
/// case conversion, validation, and masking.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  /// No effect if the string is empty or already capitalized.
  ///
  /// Example: "hello".capitalize() -> "Hello"
  String get capitalize {
    // Check if the string is empty before attempting capitalization
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Limits the string to [maxLength] characters and adds "..." if it is truncated.
  /// If the string is already shorter than [maxLength], returns it as is.
  ///
  /// Example: "Hello World".limit(5) -> "Hello..."
  String limit(int maxLength) {
    // Return original string if length is within maxLength limit
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Basic email validation check using a standard regular expression.
  /// Returns true if the string is a valid email format.
  bool get isValidEmail {
    // Regular expression for validating email format
    final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Removes characters that are not letters (a-z), digits (0-9) or spaces.
  /// Effectively strips all punctuation and symbols from the string.
  String get removeSpecialCharacters {
    // Regex for capturing any character that is NOT a letter, digit or space
    return replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');
  }

  /// Converts the string to Title Case format.
  /// Each word's first letter will be converted to upper case.
  ///
  /// Example: "hello world" -> "Hello World"
  String get toTitleCase {
    if (isEmpty) return this;
    // Split by space, capitalize each word, and join back
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Extracts initials from the string using only the first character of words.
  /// Always returns capitalized initials.
  ///
  /// Example: "Hello World" -> "HW"
  String get initials {
    if (isEmpty) return '';
    final words = split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Returns the total number of words in the string based on whitespace splitting.
  /// Empty strings return 0.
  int get wordCount {
    if (isEmpty) return 0;
    return split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  /// Returns true if the string can be parsed as a double value.
  /// Does not allow leading or trailing whitespace.
  bool get isNumeric {
    if (isEmpty) return false;
    return double.tryParse(this) != null;
  }

  /// Returns a new string with all of its characters in reverse order.
  ///
  /// Example: "abc".reverse -> "cba"
  String get reverse {
    return split('').reversed.join('');
  }

  /// Truncates the string to exactly [maxLength] characters without ellipsis.
  ///
  /// Optionally appends [suffix] if truncated. Default is empty string.
  String truncate(int maxLength, {String suffix = ''}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Converts the string to kebab-case (hyphen-separated lowercase).
  ///
  /// Example: "Hello World" -> "hello-world"
  String get toKebabCase {
    final result = replaceAllMapped(RegExp(r'[A-Z]'), (Match m) {
      return (m.start > 0 ? '-' : '') + m[0]!;
    });
    return result
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-zA-Z0-9\-]'), '')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '')
        .toLowerCase();
  }

  /// Converts the string to snake_case (underscore-separated lowercase).
  ///
  /// Example: "Hello World" -> "hello_world"
  String get toSnakeCase {
    final result = replaceAllMapped(RegExp(r'[A-Z]'), (Match m) {
      return (m.start > 0 ? '_' : '') + m[0]!;
    });
    return result
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '')
        .toLowerCase();
  }

  /// Converts the string to camelCase (starts with lower case).
  ///
  /// Example: "hello world" -> "helloWorld"
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(
      RegExp(r'[\s_-]+'),
    ).where((w) => w.isNotEmpty).map((w) => w.toLowerCase()).toList();
    if (words.isEmpty) return this;

    final buffer = StringBuffer(words[0]);
    for (var i = 1; i < words.length; i++) {
      buffer.write(words[i].capitalize);
    }
    return buffer.toString();
  }

  /// Checks if the string consists only of alphanumeric characters (a-z, A-Z, 0-9).
  /// Returns false if the string is empty.
  bool get isAlphanumeric {
    if (isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Converts the string to PascalCase (UpperCamelCase).
  ///
  /// Example: "hello world" -> "HelloWorld"
  String get toPascalCase {
    if (isEmpty) return this;

    // First, split by existing separators (space, underscore, hyphen)
    final words = split(RegExp(r'[\s_-]+')).where((w) => w.isNotEmpty).toList();

    if (words.length > 1) {
      return words.map((w) => w.capitalize).join('');
    }

    // If no explicit separators, handle camelCase/PascalCase by adding spaces before capitals
    final withSpaces = replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    );

    if (withSpaces == this) {
      return capitalize;
    }

    return withSpaces.split(' ').map((w) => w.capitalize).join('');
  }

  /// Returns true if the string contains at least one numeric digit (0-9).
  bool get containsDigit => RegExp(r'\d').hasMatch(this);

  /// Returns true if the string is empty or contains only whitespace characters.
  bool get isBlank => trim().isEmpty;

  /// Removes all whitespace characters from the string.
  ///
  /// Example: "Hello World".removeWhitespace -> "HelloWorld"
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Checks if the string contains any of the provided [values].
  ///
  /// Returns `true` if any [values] are present in the string.
  bool containsAny(List<String> values) {
    return values.any((value) => contains(value));
  }

  /// Checks if the string contains only digits (0-9).
  bool get containsOnlyDigits {
    if (isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Checks if the string contains only alphabetic characters (a-z, A-Z).
  bool get isAlpha {
    if (isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Masks the string with [maskChar] between [start] and [end] indices.
  ///
  /// Useful for sensitive data like credit cards or emails.
  String mask({int start = 0, int? end, String maskChar = '*'}) {
    if (isEmpty) return this;
    final actualEnd = end ?? length;
    if (start < 0 || start >= length || actualEnd <= start) return this;

    final prefix = substring(0, start);
    final suffix = actualEnd < length ? substring(actualEnd) : '';
    final maskLength = actualEnd - start;
    final mask = maskChar * maskLength;

    return '$prefix$mask$suffix';
  }

  /// Checks if the string is a valid URL.
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(this);
  }

  /// Repeats the string [times] number of times.
  String repeat(int times) {
    if (times <= 0) return '';
    return this * times;
  }

  /// Converts the string to a URL-friendly slug.
  String slugify() {
    return toLower()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'[\s_]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Helper to convert to lowercase (internal use).
  String toLower() => toLowerCase();

  /// Counts the number of occurrences of a [pattern] in the string.
  int countOccurrences(String pattern) {
    if (pattern.isEmpty || isEmpty) return 0;
    return pattern.allMatches(this).length;
  }

  /// Checks if the string is a valid JSON structure (starts with { or [ and ends with } or ]).
  bool get isJson {
    if (isEmpty) return false;
    final trimmed = trim();
    return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'));
  }

  /// Converts string "true" (case-insensitive) to boolean true, others to false.
  bool get toBool {
    return toLowerCase() == 'true';
  }

  /// Checks if the string contains at least one uppercase letter.
  bool get hasUpperCase => contains(RegExp(r'[A-Z]'));

  /// Checks if the string contains at least one lowercase letter.
  bool get hasLowerCase => contains(RegExp(r'[a-z]'));

  /// Checks if the string contains at least one special character.
  bool get hasSpecialCharacters => contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  /// Replaces multiple whitespace characters with a single space.
  String get collapseWhitespace {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Removes all non-numeric characters from the string.
  String get removeNonNumeric {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Checks if the string contains only ASCII characters.
  bool get isAscii {
    if (isEmpty) return false;
    return RegExp(r'^[\x00-\x7F]+$').hasMatch(this);
  }

  /// Checks if the entire string is upper case.
  bool get isUpperCase {
    if (isEmpty) return false;
    return this == toUpperCase();
  }

  /// Checks if the entire string is lower case.
  bool get isLowerCase {
    if (isEmpty) return false;
    return this == toLowerCase();
  }

  /// Returns the left [length] characters of the string.
  String left(int length) {
    if (length <= 0) return '';
    if (length >= this.length) return this;
    return substring(0, length);
  }

  /// Returns the right [length] characters of the string.
  String right(int length) {
    if (length <= 0) return '';
    if (length >= this.length) return this;
    return substring(this.length - length);
  }

  /// Returns the number of lines in the string.
  int get countLines {
    if (isEmpty) return 0;
    return split('\n').length;
  }

  /// Encodes the string to Base64.
  String get toBase64 {
    return base64.encode(utf8.encode(this));
  }

  /// Decodes the string from Base64.
  String get fromBase64 {
    return utf8.decode(base64.decode(this));
  }

  /// Removes all numeric digits from the string.
  String get removeDigits {
    return replaceAll(RegExp(r'\d'), '');
  }

  /// Removes all alphabetic characters from the string.
  String get removeLetters {
    return replaceAll(RegExp(r'[a-zA-Z]'), '');
  }

  /// Converts the string to sentence case (only first letter capitalized).
  String get toSentenceCase {
    if (isEmpty) return this;
    final lower = toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  /// Masks the string showing only first two and last two characters.
  String get maskSensitiveInfo {
    if (length <= 4) return '*' * length;
    return '${substring(0, 2)}${'*' * (length - 4)}${substring(length - 2)}';
  }

  /// Checks if the string contains only alphabetic characters.
  bool get containsOnlyLetters {
    if (isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Checks if the string contains only numeric characters.
  bool get containsOnlyNumbers {
    if (isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  // End of StringExtensions
}
