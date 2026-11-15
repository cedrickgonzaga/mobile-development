import 'package:flutter/material.dart';

/// Every colour in the app comes from here — the palette in the brief plus a
/// few derived tints so the code never hardcodes a hex value inline.
class AppColors {
  AppColors._();

  // Core palette (exact values from the design brief).
  static const charcoal = Color(0xFF282A2E); // primary text & heavy UI
  static const muted = Color(0xFF697177); // secondary text / subtitles
  static const white = Color(0xFFFFFFFF); // cards & widgets
  static const sage = Color(0xFFE2EFE7); // main app background
  static const powderBlue = Color(0xFFE1E8ED); // secondary surfaces
  static const purple = Color(0xFF9A9DE5); // primary accent
  static const teal = Color(0xFF9CBFB4); // positive values
  static const yellow = Color(0xFFFCD378); // warnings & highlights

  /// Derived token: the palette has no red, so destructive actions use this
  /// muted terracotta, which sits comfortably next to the sage background.
  static const danger = Color(0xFFC2695F);

  // Translucent washes used for chips, outlines and soft highlights.
  static const charcoal08 = Color(0x14282A2E);
  static const charcoal04 = Color(0x0A282A2E);
  static const charcoal72 = Color(0xB8282A2E);
  static const purple16 = Color(0x299A9DE5);
  static const purple10 = Color(0x1A9A9DE5);
  static const teal16 = Color(0x299CBFB4);
  static const yellow24 = Color(0x3DFCD378);
  static const white70 = Color(0xB3FFFFFF);
}
