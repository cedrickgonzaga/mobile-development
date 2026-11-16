import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';

/// Presentation details for each category, kept out of the model so
/// `models/` stays free of Flutter widgets and icons.
extension ExpenseCategoryVisuals on ExpenseCategory {
  IconData get icon {
    return switch (this) {
      ExpenseCategory.food => Icons.restaurant_rounded,
      ExpenseCategory.transport => Icons.directions_bus_filled_rounded,
      ExpenseCategory.bills => Icons.receipt_long_rounded,
      ExpenseCategory.shopping => Icons.shopping_bag_rounded,
      ExpenseCategory.health => Icons.favorite_rounded,
      ExpenseCategory.entertainment => Icons.movie_rounded,
      ExpenseCategory.others => Icons.category_rounded,
    };
  }

  /// Base accent colour from the palette.
  Color get accent {
    return switch (this) {
      ExpenseCategory.food => AppColors.peach,
      ExpenseCategory.transport => AppColors.purple,
      ExpenseCategory.bills => AppColors.teal,
      ExpenseCategory.shopping => AppColors.powderBlue,
      ExpenseCategory.health => AppColors.teal,
      ExpenseCategory.entertainment => AppColors.purple,
      ExpenseCategory.others => AppColors.muted,
    };
  }

  /// Soft background used behind [icon].
  Color get tint => accent.withValues(alpha: 0.4);
}
