import 'package:flutter/widgets.dart';

/// 4pt spacing scale, so paddings stay consistent across screens.
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  /// Horizontal page padding used by every screen.
  static const pagePadding = EdgeInsets.symmetric(horizontal: 20);

  /// Bottom padding that clears the floating action button / nav bar.
  static const bottomSafe = EdgeInsets.only(bottom: 32);

  /// Standard shadow for white cards on the sage background.
  static const cardShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F282A2E),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
