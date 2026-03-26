class PasswordValidator {
  static const int minLength = 8;
  static const int maxLength = 72;

  /// Validate password according to requirements:
  /// - At least 8 characters
  /// - At most 72 characters
  /// - At least one lowercase letter
  /// - At least one uppercase letter
  /// - At least one digit
  static String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'passwordRequired';
    }

    if (password.length < minLength) {
      return 'passwordMinLengthError';
    }

    if (password.length > maxLength) {
      return 'passwordMaxLengthError';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'passwordMissingLowercase';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'passwordMissingUppercase';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'passwordMissingDigits';
    }

    return null;
  }

  /// Check only length and complexity, used for real-time feedback.
  static List<String> getValidationErrors(String password) {
    final errors = <String>[];

    if (password.isEmpty) {
      return ['passwordRequired'];
    }

    if (password.length < minLength) {
      errors.add('passwordTooShort');
    }

    if (password.length > maxLength) {
      errors.add('passwordTooLong');
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('passwordNeedsLowercase');
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('passwordNeedsUppercase');
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('passwordNeedsDigits');
    }

    return errors;
  }
}
