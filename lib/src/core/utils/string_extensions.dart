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
}
