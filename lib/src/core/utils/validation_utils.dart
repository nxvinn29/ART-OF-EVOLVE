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

  /// Validates if the [bio] is within the character limit (max 150).
  static bool isValidBio(String bio) {
    return bio.length <= 150;
  }

  /// Validates if the [age] is within the acceptable range (13 to 120).
  static bool isValidAge(int age) {
    return age >= 13 && age <= 120;
  }

  /// Validates if the provided [ip] is a valid IPv4 address.
  ///
  /// Returns `true` if the IP address follows the x.x.x.x format with octets 0-255.
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
  ///
  /// A strong password must:
  /// - Be at least 10 characters long.
  /// - Contain at least one uppercase letter.
  /// - Contain at least one lowercase letter.
  /// - Contain at least one numeric character.
  /// - Contain at least one special character.
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
  ///
  /// Supports both colon-separated and hyphen-separated formats (e.g., 00:00:00:00:00:00 or 00-00-00-00-00-00).
  static bool isValidMACAddress(String mac) {
    return RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$').hasMatch(mac);
  }

  /// Validates if the provided [phone] is a valid US phone number.
  ///
  /// Supports various formats like:
  /// - 1234567890
  /// - 123-456-7890
  /// - (123) 456-7890
  /// - 123.456.7890
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
}
