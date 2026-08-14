import 'package:flutter/material.dart';

const String baseUrl = 'http://localhost:3000/api';

class AppColors {
  static const Color ink = Color(0xFF1B1410);
  static const Color inkSoft = Color(0xFF4A4038);
  static const Color paper = Color(0xFFFAF6F0);
  static const Color paperDim = Color(0xFFF2EBE1);
  static const Color sand = Color(0xFFEAE0D0);
  static const Color crimson = Color(0xFFC31F3B);
  static const Color crimsonDark = Color(0xFF8F1329);
  static const Color verified = Color(0xFF1F6F5C);

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
  static const double md = 14;
  static const double lg = 18;
  static const double pill = 999;
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