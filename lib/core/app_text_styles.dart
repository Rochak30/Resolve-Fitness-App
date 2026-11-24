import 'package:flutter/material.dart';

/// Typography scale copied from the Stitch design (Plus Jakarta Sans).
class AppTextStyles {
  static const String _family = 'PlusJakartaSans';

  // ---------- Labels ----------
  static TextStyle get labelSm => const TextStyle(
    fontFamily: _family,
    fontSize: 11,
    height: 14 / 11,
    letterSpacing: 0.66, // 0.06em
    fontWeight: FontWeight.w700,
  );

  static TextStyle get labelMd => const TextStyle(
    fontFamily: _family,
    fontSize: 13,
    height: 16 / 13,
    letterSpacing: 0.52, // 0.04em
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLg => const TextStyle(
    fontFamily: _family,
    fontSize: 15,
    height: 20 / 15,
    letterSpacing: 0.3, // 0.02em
    fontWeight: FontWeight.w600,
  );

  // ---------- Body ----------
  static TextStyle get bodySm => const TextStyle(
    fontFamily: _family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMd => const TextStyle(
    fontFamily: _family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  // ---------- Headlines ----------
  static TextStyle get headlineSm => const TextStyle(
    fontFamily: _family,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -0.18, // -0.01em
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headlineLg => const TextStyle(
    fontFamily: _family,
    fontSize: 26,
    height: 32 / 26,
    letterSpacing: -0.52, // -0.02em
    fontWeight: FontWeight.w800,
  );
}
