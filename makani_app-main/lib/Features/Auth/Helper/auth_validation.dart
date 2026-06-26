class AuthValidation {
  static final RegExp _emailRegex = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  );

  static bool isValidEmail(String value) => _emailRegex.hasMatch(value.trim());

  static bool isStrongPassword(String value) => value.trim().length >= 6;

  static bool isValidPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8;
  }
}

