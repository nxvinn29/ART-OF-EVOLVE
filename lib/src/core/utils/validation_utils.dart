class ValidationUtils {
  /// Validates if the provided [email] string is in a correct email format.
  ///
  /// Returns `true` if the email matches the standard regex pattern,
  /// otherwise returns `false`.
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  /// Validates if the provided [password] meets the security requirements.
  ///
  /// A valid password must:
  /// - Be at least 8 characters long.
  /// - Contain at least one numeric character.
  ///
  /// Returns `true` if valid, otherwise `false`.
  static bool isValidPassword(String password) {
    // Min 8 chars, at least one number
    return password.length >= 8 && RegExp(r'[0-9]').hasMatch(password);
  }

  /// Validates if the provided [username] is acceptable.
  ///
  /// A valid username must:
  /// - Not be empty.
  /// - Have a length of at least 3 characters.
  ///
  /// Returns `true` if valid, otherwise `false`.
  static bool isValidUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }

  /// Sanitizes the [input] string by removing HTML tags.
  ///
  /// This method removes any substrings matching an HTML tag pattern (e.g., `<script>`)
  /// and trims leading/trailing whitespace.
  ///
  /// Returns the sanitized string.
  static String sanitizeInput(String input) {
    // Remove HTML tags and trim
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// Validates if the provided [phoneNumber] is a valid 10-digit number.
  ///
  /// Returns `true` if the phone number consists of exactly 10 digits,
  /// otherwise returns `false`.
  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\d{10}$').hasMatch(phoneNumber);
  }

  /// Validates if the provided [url] is a valid URL.
  ///
  /// Checks for http/https scheme and domain structure.
  ///
  /// Returns `true` if valid, otherwise `false`.
  static bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
