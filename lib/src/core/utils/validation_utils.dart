/// Validation utility class for the Art of Evolve project.
///
/// This file contains methods for validating common input types such as email,
/// passwords, phone numbers, and more.
class ValidationUtils {
  /// Validates if the provided [email] string adheres to a standard email format.
  ///
  /// Returns `true` if the email matches the regex pattern,
  /// otherwise returns `false`.
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  /// Validates if the provided [password] meets basic security requirements.
  ///
  /// A valid password must:
  /// - Be at least 8 characters long.
  /// - Contain at least one numeric character (0-9).
  ///
  /// Returns `true` if valid, otherwise `false`.
  static bool isValidPassword(String password) {
    return password.length >= 8 && RegExp(r'[0-9]').hasMatch(password);
  }

  /// Validates if the provided [username] meets length and presence requirements.
  ///
  /// A valid username must:
  /// - Not be empty (non-blank).
  /// - Have a length of at least 3 characters.
  ///
  /// Returns `true` if valid, otherwise `false`.
  static bool isValidUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }

  /// Sanitizes the [input] string by stripping out any HTML tags.
  ///
  /// This method removes any substrings matching an HTML tag pattern (e.g., `<script>`)
  /// and trims leading/trailing whitespace.
  ///
  /// Returns the sanitized and trimmed string.
  static String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// Validates if the provided [phoneNumber] is a valid 10-digit number.
  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\d{10}$').hasMatch(phoneNumber);
  }

  /// Validates if the provided [url] is a valid URL.
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
  static bool isValidHexColor(String color) {
    return RegExp(
      r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
    ).hasMatch(color);
  }

  /// Validates if the [bio] is within the character limit (max 150).
  static bool isValidBio(String bio) {
    return bio.length <= 150;
  }

  /// Validates if the [age] is within the acceptable range (13 to 120).
  static bool isValidAge(int age) {
    return age >= 13 && age <= 120;
  }

  /// Validates if the provided [ip] is a valid IPv4 address.
  static bool isValidIPAddress(String ip) {
    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(ip);
  }

  /// Validates if the provided [ip] is a valid IPv6 address.
  static bool isValidIPAddressV6(String ip) {
    final ipV6Regex = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
    );
    return ipV6Regex.hasMatch(ip);
  }

  /// Validates if the provided [password] is a strong password.
  static bool isValidStrongPassword(String password) {
    if (password.length < 10) return false;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  /// Validates if the provided [mac] address is a valid MAC address.
  static bool isValidMACAddress(String mac) {
    return RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$').hasMatch(mac);
  }

  /// Validates if the provided [phone] is a valid US phone number.
  static bool isValidUSPhoneNumber(String phone) {
    return RegExp(
      r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$',
    ).hasMatch(phone);
  }

  /// Validates if the provided [uuid] is a valid UUID.
  static bool isValidUuid(String uuid) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(uuid);
  }

  /// Validates if the provided [cardNumber] is a valid credit card number using Luhn algorithm.
  static bool isValidCreditCard(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) return false;
    int sum = 0;
    bool alternate = false;
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n = (n % 10) + 1;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  /// Validates if the provided [version] is a valid semantic version.
  static bool isValidSemVer(String version) {
    return RegExp(
      r'^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$',
    ).hasMatch(version);
  }

  /// Checks if the provided [str] is a valid double.
  static bool isDouble(String str) {
    return double.tryParse(str) != null;
  }

  /// Checks if the provided [str] is a valid integer.
  static bool isInt(String str) {
    return int.tryParse(str) != null;
  }

  /// Validates if the provided [port] is a valid port number (0-65535).
  static bool isValidPort(int port) {
    return port >= 0 && port <= 65535;
  }

  /// Validates if the provided [lat] is a valid latitude (-90 to 90).
  static bool isValidLatitude(double lat) {
    return lat >= -90.0 && lat <= 90.0;
  }

  /// Validates if the provided [password] has minimum complexity.
  static bool isValidPasswordComplexity(String password) {
    if (password.length < 8) return false;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasDigits;
  }

  /// Validates if the provided [username] has minimum complexity.
  static bool isValidUsernameComplexity(String username) {
    return username.length >= 3 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username);
  }

  /// Validates if the [input] length is within [min] and [max].
  static bool isValidLength(String input, int min, int max) {
    return input.length >= min && input.length <= max;
  }
}
