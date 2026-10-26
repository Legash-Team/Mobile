import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The backend base URL loaded from dotenv ('API_BASE_URL') at runtime.
/// All API requests use this single base URL, with no hardcoded fallback
/// or compile-time `--dart-define` requirement.
String get baseUrl {
  if (!dotenv.isInitialized) {
    throw StateError(
      'flutter_dotenv has not been initialized. Ensure await dotenv.load() is called before accessing API_BASE_URL.',
    );
  }

  final raw = dotenv.env['API_BASE_URL'];
  if (raw == null || raw.trim().isEmpty) {
    throw StateError(
      'API_BASE_URL is not set in .env. Please configure API_BASE_URL in your .env file.',
    );
  }

  final trimmed = raw.trim();
  final sanitized = trimmed.replaceAll(RegExp(r'/+$'), '');
  final uri = Uri.tryParse(sanitized);

  if (uri == null ||
      !uri.hasScheme ||
      (!uri.isScheme('http') && !uri.isScheme('https')) ||
      uri.host.isEmpty) {
    throw FormatException(
      'Invalid API_BASE_URL in .env: "$trimmed". It must be a valid HTTP or HTTPS URL (e.g. http://10.0.2.2:3000 or https://api.example.com).',
    );
  }

  return sanitized;
}

String get apiBaseUrl => baseUrl;

class AppColors {
  static const Color ink = Color(0xFF1B1410);
  static const Color inkSoft = Color(0xFF4A4038);
  static const Color paper = Color(0xFFFAF7F2);
  static const Color paperDim = Color(0xFFF5EFEB);
  static const Color sand = Color(0xFFEAE0D0);
  static const Color crimson = Color(0xFFC21838);
  static const Color crimsonDark = Color(0xFF8F1329);
  static const Color verified = Color(0xFF1F6F5C);
  static const Color cardBorder = Color(0xFFE5DFD7);
  static const Color pillGreen = Color(0xFFD4EDDA);
  static const Color primary = crimson;
  static const Color primaryDark = crimsonDark;
  static const Color error = crimson;
  static const Color background = paper;
  static const Color surface = Colors.white;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkSoft;
  static const Color border = sand;
  static const Color borderFocused = crimson;
}
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 50;
}
class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
class AppFonts {
  static const String sans = 'IBM Plex Sans';
  static const String mono = 'IBM Plex Mono';
}