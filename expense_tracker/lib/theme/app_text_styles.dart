import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type scale for Plus Jakarta Sans.
///
/// Headings: bold / extra bold with tight negative tracking (the brief asks for
/// -0.02em to -0.04em; values below are that ratio converted to logical pixels
/// for each size, e.g. 40px × -0.04 = -1.6).
/// Body: regular / medium with neutral or slightly loose tracking.
class AppTextStyles {
  AppTextStyles._();

  static const display = TextStyle(
    fontSize: 40,
    height: 1.06,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.6, // -0.04em
    color: AppColors.charcoal,
  );

  static const h1 = TextStyle(
    fontSize: 30,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2, // -0.04em
    color: AppColors.charcoal,
  );

  static const h2 = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.66, // -0.03em
    color: AppColors.charcoal,
  );

  static const h3 = TextStyle(
    fontSize: 17,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.34, // -0.02em
    color: AppColors.charcoal,
  );

  /// Small uppercase eyebrow label above sections.
  static const eyebrow = TextStyle(
    fontSize: 11.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: AppColors.muted,
  );

  static const body = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: AppColors.charcoal,
  );

  static const bodyMedium = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.charcoal,
  );

  static const bodyStrong = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.charcoal,
  );

  static const caption = TextStyle(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.muted,
  );

  static const captionSmall = TextStyle(
    fontSize: 11.5,
    height: 1.3,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.muted,
  );

  /// Big money figures — tabular figures keep columns from jittering.
  static const amount = TextStyle(
    fontSize: 34,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.4,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.charcoal,
  );

  static const amountSmall = TextStyle(
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.charcoal,
  );

  static const amountNegative = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.danger,
  );
}
