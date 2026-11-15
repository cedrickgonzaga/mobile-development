import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../utils/category_visuals.dart';

/// Rounded, tinted square that holds a category icon.
/// Used in expense rows, the Home breakdown and the Add form.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.category,
    this.size = 44,
  });

  final ExpenseCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.tint,
        borderRadius: BorderRadius.circular(size * 0.34),
      ),
      child: Icon(
        category.icon,
        size: size * 0.48,
        color: AppColors.charcoal,
      ),
    );
  }
}
