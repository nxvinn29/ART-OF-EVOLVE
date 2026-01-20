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
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
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

  // End of StringExtensions
}
