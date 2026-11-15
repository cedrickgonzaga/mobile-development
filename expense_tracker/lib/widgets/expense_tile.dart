import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'category_badge.dart';

/// One expense row: tinted category icon, title + meta, amount on the right.
/// The surrounding white card is supplied by the parent.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  final Expense expense;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            CategoryBadge(category: expense.category),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyStrong,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${expense.category.label} · ${Formatters.date(expense.date)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(Formatters.peso(expense.amount), style: AppTextStyles.amountSmall),
          ],
        ),
      ),
    );
  }
}
