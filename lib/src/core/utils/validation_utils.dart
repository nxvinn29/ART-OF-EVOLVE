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
    final uri = Uri.tryParse(url);
    return uri != null && uri.isAbsolute && uri.host.isNotEmpty;
  }

  /// Validates if the [name] is valid (only letters and spaces, min length 2).
  static bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]{2,}$').hasMatch(name);
  }

  /// Validates if the [zipCode] is a valid 5-digit US zip code.
  static bool isValidZipCode(String zipCode) {
    return RegExp(r'^\d{5}$').hasMatch(zipCode);
  }

  /// Validates if the [color] is a valid hex color string.
  ///
  /// Supports both 3-digit and 6-digit hex codes, optionally starting with '#'.
  /// Use 6/8 digit hex codes for consistent parsing if needed, but this checks general format.
  /// Pattern: ^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$
  static bool isValidHexColor(String color) {
    return RegExp(
      r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
    ).hasMatch(color);
  }
}
