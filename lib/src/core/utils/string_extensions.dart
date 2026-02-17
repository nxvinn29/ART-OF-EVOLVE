/// Extension methods for [String] to add common manipulation capabilities.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Example: "hello" -> "Hello"
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Limits the string to [maxLength] characters and adds "..." if truncated.
  ///
  /// Example: "Hello World".limit(5) -> "Hello..."
  String limit(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Basic email validation check.
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Removes special characters, leaving only alphanumeric characters and spaces.
  String get removeSpecialCharacters {
    return replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');
  }

  /// Converts the string to Title Case.
  ///
  /// Example: "hello world" -> "Hello World"
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Extracts initials from the string.
  ///
  /// Example: "Hello World" -> "HW"
  /// Takes the first character of the first two words.
  String get initials {
    if (isEmpty) return '';
    final words = split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Returns the number of words in the string.
  int get wordCount {
    if (isEmpty) return 0;
    return split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  /// Checks if the string is numeric.
  bool get isNumeric {
    if (isEmpty) return false;
    return double.tryParse(this) != null;
  }

  /// Reverses the string.
  String get reverse {
    return split('').reversed.join('');
  }

  /// Truncates the string to [maxLength] characters.
  ///
  /// Optionally appends [suffix] if truncated. Default is empty string.
  String truncate(int maxLength, {String suffix = ''}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Converts the string to kebab-case.
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

  /// Converts the string to snake_case.
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

  /// Converts the string to camelCase.
  ///
  /// Example: "hello world" -> "helloWorld"
  /// Example: "hello_world" -> "helloWorld"
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

  /// Checks if the string contains only alphanumeric characters.
  bool get isAlphanumeric {
    if (isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Converts the string to PascalCase.
  ///
  /// Example: "hello world" -> "HelloWorld"
  /// Example: "hello_world" -> "HelloWorld"
  /// Example: "helloWorld" -> "HelloWorld"
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

  /// Checks if the string contains at least one numeric digit.
  bool get containsDigit => RegExp(r'\d').hasMatch(this);

  /// Checks if the string is null, empty or consists only of whitespace.
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

  // End of StringExtensions
}
