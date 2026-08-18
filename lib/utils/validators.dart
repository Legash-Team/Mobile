class Validators {
  static final RegExp _phoneRegex = RegExp(r'^\+251\d{9}$');
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:''"\\|,.<>/?]');

  static bool isValidEthiopianPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim());
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!_uppercaseRegex.hasMatch(password)) return false;
    if (!_specialCharRegex.hasMatch(password)) return false;
    return true;
  }

  static bool confirmPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidEthiopianPhone(value)) {
      return 'Enter a valid Ethiopian phone (+251XXXXXXXXX)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!isValidPassword(value)) {
      return 'Min 8 chars, 1 uppercase, 1 special char';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (!confirmPasswordMatch(password, value)) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}