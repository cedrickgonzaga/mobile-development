import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/page_routes.dart';
import '../widgets/app_card.dart';
import '../widgets/category_badge.dart';
import 'expense_form_screen.dart';

/// Read-only view of one expense, with edit and delete actions.
class ExpenseDetailsScreen extends StatefulWidget {
  const ExpenseDetailsScreen({super.key, required this.expenseId});

  final int expenseId;

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  bool _loading = true;
  Expense? _expense;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final expense = await DatabaseHelper.instance.getExpenseById(
      widget.expenseId,
    );
    if (!mounted) return;
    setState(() {
      _expense = expense;
      _loading = false;
    });
  }

  Future<void> _edit() async {
    final expense = _expense;
    if (expense == null) return;
    final saved = await Navigator.of(context).push<bool>(
      fadeRoute(ExpenseFormScreen(expense: expense)),
    );
    if (saved != true) return;
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense updated')),
    );
  }

  Future<void> _confirmDelete() async {
    final expense = _expense;
    if (expense == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete expense?'),
          content: Text(
            '"${expense.title}" will be permanently removed from this device. '
            'This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    await DatabaseHelper.instance.deleteExpense(expense.id!);
    if (!mounted) return;
    Navigator.of(context).pop('deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _expense == null
                ? Center(
                    child: Text(
                      'This expense no longer exists.',
                      style: AppTextStyles.caption,
                    ),
                  )
                : _DetailsBody(
                    expense: _expense!,
                    onEdit: _edit,
                    onDelete: _confirmDelete,
                  ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              CategoryBadge(category: expense.category, size: 56),
              const SizedBox(height: AppSpacing.lg),
              Text(Formatters.peso(expense.amount),
                  style: AppTextStyles.amount),
              const SizedBox(height: AppSpacing.sm),
              Text(
                expense.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                Formatters.fullDate(expense.date),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Column(
            children: [
              _InfoRow(label: 'Category', value: expense.category.label),
              const Divider(height: 1),
              _InfoRow(label: 'Date', value: Formatters.date(expense.date)),
              const Divider(height: 1),
              _InfoRow(
                label: 'Added',
                value: Formatters.date(expense.createdAt),
              ),
            ],
          ),
        ),

        if (expense.hasNote) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOTE', style: AppTextStyles.eyebrow),
                const SizedBox(height: AppSpacing.sm),
                Text(expense.note, style: AppTextStyles.body),
              ],
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xxl),
        FilledButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Edit expense'),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: AppColors.danger,
          ),
          label: const Text(
            'Delete',
            style: TextStyle(color: AppColors.danger),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.danger.withValues(alpha: 0.35)),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.caption),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
