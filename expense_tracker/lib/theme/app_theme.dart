import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Material 3 theme built from the palette and type scale.
class AppTheme {
  AppTheme._();

  static const fontFamily = 'PlusJakartaSans';

  /// Default corner radii used across cards, fields and sheets.
  static const cardRadius = 24.0;
  static const fieldRadius = 16.0;

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.purple,
      onPrimary: AppColors.charcoal,
      primaryContainer: AppColors.purple16,
      onPrimaryContainer: AppColors.charcoal,
      secondary: AppColors.teal,
      onSecondary: AppColors.charcoal,
      secondaryContainer: AppColors.teal16,
      onSecondaryContainer: AppColors.charcoal,
      tertiary: AppColors.yellow,
      onTertiary: AppColors.charcoal,
      tertiaryContainer: AppColors.yellow24,
      onTertiaryContainer: AppColors.charcoal,
      error: AppColors.danger,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.charcoal,
      onSurfaceVariant: AppColors.muted,
      outline: AppColors.charcoal08,
      outlineVariant: AppColors.charcoal08,
      shadow: AppColors.charcoal,
      scrim: AppColors.charcoal,
      inverseSurface: AppColors.charcoal,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.purple,
    );

    final textTheme = const TextTheme(
      displayLarge: AppTextStyles.display,
      displayMedium: AppTextStyles.h1,
      displaySmall: AppTextStyles.h1,
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      titleLarge: AppTextStyles.h3,
      titleMedium: AppTextStyles.bodyStrong,
      titleSmall: AppTextStyles.bodyMedium,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.bodyStrong,
      labelMedium: AppTextStyles.caption,
      labelSmall: AppTextStyles.captionSmall,
    ).apply(fontFamily: fontFamily);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.sage,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2,
        iconTheme: const IconThemeData(color: AppColors.charcoal, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.charcoal),
          foregroundColor: const WidgetStatePropertyAll(AppColors.white),
          overlayColor: const WidgetStatePropertyAll(AppColors.charcoal08),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(Size(0, 56)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.charcoal),
          overlayColor: const WidgetStatePropertyAll(AppColors.charcoal04),
          minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.charcoal08),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.charcoal),
          overlayColor: const WidgetStatePropertyAll(AppColors.charcoal04),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
        labelStyle: AppTextStyles.caption,
        floatingLabelStyle: AppTextStyles.captionSmall.copyWith(
          color: AppColors.muted,
        ),
        errorStyle: AppTextStyles.captionSmall.copyWith(
          color: AppColors.danger,
          fontWeight: FontWeight.w500,
        ),
        helperStyle: AppTextStyles.captionSmall,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.charcoal08),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.charcoal08),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: AppColors.charcoal04),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.purple16,
        elevation: 0,
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? AppColors.charcoal : AppColors.muted,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTextStyles.captionSmall.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.charcoal : AppColors.muted,
            letterSpacing: 0.2,
          );
        }),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.white),
        actionTextColor: AppColors.yellow,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 88),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: AppTextStyles.h2,
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.charcoal08,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.purple16,
        disabledColor: AppColors.charcoal04,
        side: const BorderSide(color: AppColors.charcoal08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        secondaryLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
        ),
        showCheckmark: false,
        elevation: 0,
        pressElevation: 0,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.charcoal08,
        thickness: 1,
        space: 1,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.charcoal,
        textColor: AppColors.charcoal,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.purple,
        linearTrackColor: AppColors.charcoal08,
        circularTrackColor: AppColors.charcoal08,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColors.purple16,
        headerForegroundColor: AppColors.charcoal,
        dividerColor: AppColors.charcoal08,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        weekdayStyle: AppTextStyles.captionSmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        dayStyle: AppTextStyles.bodyMedium,
        todayForegroundColor: const WidgetStatePropertyAll(AppColors.charcoal),
        todayBorder: const BorderSide(color: AppColors.purple),
        yearStyle: AppTextStyles.caption,
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.purple,
        selectionColor: AppColors.purple16,
        selectionHandleColor: AppColors.purple,
      ),

      splashColor: AppColors.charcoal04,
      highlightColor: Colors.transparent,
    );
  }
}
