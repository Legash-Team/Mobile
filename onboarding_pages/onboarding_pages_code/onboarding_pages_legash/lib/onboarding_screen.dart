import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//design template

//color style
abstract final class OnboardingColor {
  static const ink = Color(0xFF1B1410);
  static const inkSoft = Color(0xFF4A4038);
  static const paper = Color(0xFFFAF6F0);
  static const paperDim = Color(0xFFF2EBE1);
  static const sand = Color(0xFFEAE0D0);
  static const crimson = Color(0xFFC31F3B);
  static const crimsonDark = Color(0xFF8F1329);
  static const verified = Color(0xFF1F6F5C);
}

abstract final class OnboardingRadius {
  static const sm   = 8.0;
  static const md   = 14.0;
  static const lg   = 18.0;
  static const pill = 999.0;
}

abstract final class OnboardingSpace {
  static const xs  = 8.0;
  static const sm  = 12.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 32.0;
}

//text style
abstract final class LFont {
  static const sans = 'IBMPlexSans';
  static const mono = 'IBMPlexMono';
}

abstract final class LText {
  static TextStyle h1({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle h2({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle h3({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

   static TextStyle lede({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 17,
    height: 26 / 17,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

  static TextStyle medium({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

    static TextStyle small({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 13,
    height: 20 / 13,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

    static TextStyle button({Color? color}) => TextStyle(
    fontFamily: LFont.sans,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );

    static TextStyle monoNumeric({Color? color}) => TextStyle(
    fontFamily: LFont.mono,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle monoChip({Color? color}) => TextStyle(
    fontFamily: LFont.mono,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.inkSoft,
  );
}