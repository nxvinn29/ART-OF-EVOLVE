class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Min 8 chars, at least one number
    return password.length >= 8 && RegExp(r'[0-9]').hasMatch(password);
  }

  static bool isValidUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }

  static String sanitizeInput(String input) {
    // Remove HTML tags and trim
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
