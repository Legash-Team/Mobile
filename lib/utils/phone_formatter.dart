class PhoneFormatter {
  static String format(String input) {
    final trimmed = input.trim();
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length == 10 && digits.startsWith('0')) {
      return '+251${digits.substring(1)}';
    }

    if (digits.length == 9) {
      return '+251$digits';
    }

    if (trimmed.startsWith('+251') && trimmed.length == 13) {
      return trimmed;
    }

    return trimmed;
  }
}
