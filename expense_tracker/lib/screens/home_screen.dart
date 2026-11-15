import 'package:flutter/material.dart';

import '../data/budget_service.dart';
import '../data/database_helper.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/page_routes.dart';
import '../widgets/app_card.dart';
import '../widgets/budget_dialog.dart';
import '../widgets/category_badge.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/section_header.dart';
import 'expense_details_screen.dart';
import 'expense_form_screen.dart';

/// Home tab: month summary, budget progress, category breakdown and the most
/// recent expenses. All figures come straight from SQLite on every load.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onViewAll});

  /// Lets Home jump to the Expenses tab without importing the shell.
  final VoidCallback onViewAll;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  double _monthTotal = 0;
  int _monthCount = 0;
  Map<ExpenseCategory, double> _categoryTotals = const {};
  List<Expense> _recent = const [];
  double _budget = BudgetService.defaultMonthlyBudget;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final month = DateTime.now();
    final db = DatabaseHelper.instance;

    final total = await db.totalForMonth(month);
    final count = await db.countForMonth(month);
    final categories = await db.categoryTotalsForMonth(month);
    final recent = await db.getRecentExpenses(limit: 4);
    final budget = await BudgetService.instance.getMonthlyBudget();

    if (!mounted) return;
    setState(() {
      _monthTotal = total;
      _monthCount = count;
      _categoryTotals = categories;
      _recent = recent;
      _budget = budget;
      _loading = false;
    });
  }

  Future<void> _openAdd() async {
    final saved = await Navigator.of(context).push<bool>(
      fadeRoute(const ExpenseFormScreen()),
    );
    if (saved != true) return;
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense added')),
    );
  }

  Future<void> _openDetails(Expense expense) async {
    final id = expense.id;
    if (id == null) return;
    final result = await Navigator.of(context).push<String>(
      fadeRoute(ExpenseDetailsScreen(expenseId: id)),
    );
    // Always reload: the expense may have been edited or deleted.
    await _load();
    if (!mounted) return;
    if (result == 'deleted') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted')),
      );
    }
  }

  Future<void> _editBudget() async {
    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) => BudgetDialog(initialAmount: _budget),
    );

    if (result == null) return;
    await BudgetService.instance.setMonthlyBudget(result);
    if (!mounted) return;
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monthly budget updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense'),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _load,
          color: AppColors.purple,
          backgroundColor: AppColors.white,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              _HomeHeader(month: now, onEditBudget: _editBudget),
              const SizedBox(height: AppSpacing.xl),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                _BalanceCard(
                  total: _monthTotal,
                  count: _monthCount,
                ),
                const SizedBox(height: AppSpacing.md),
                _BudgetCard(
                  budget: _budget,
                  spent: _monthTotal,
                  onTap: _editBudget,
                ),
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(title: 'By category'),
                const SizedBox(height: AppSpacing.md),
                _CategoryBreakdown(totals: _categoryTotals),
                const SizedBox(height: AppSpacing.xxl),
                SectionHeader(
                  title: 'Recent expenses',
                  actionLabel: 'See all',
                  onAction: widget.onViewAll,
                ),
                const SizedBox(height: AppSpacing.md),
                if (_recent.isEmpty)
                  AppCard(
                    child: EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'No expenses yet',
                      message:
                          'Add your first expense and this month\'s summary '
                          'will build itself.',
                      actionLabel: 'Add expense',
                      onAction: _openAdd,
                    ),
                  )
                else
                  for (final expense in _recent)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onTap: () => _openDetails(expense),
                        child: ExpenseTile(expense: expense),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.month, required this.onEditBudget});

  final DateTime month;
  final VoidCallback onEditBudget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatters.monthYear(month),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 6),
              Text(Formatters.greeting(), style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'Here\'s how your spending looks.',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: AppColors.white,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            onPressed: onEditBudget,
            tooltip: 'Edit monthly budget',
            icon: const Icon(Icons.tune_rounded, size: 20),
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('SPENT THIS MONTH', style: AppTextStyles.eyebrow),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.purple16,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(Formatters.peso(total), style: AppTextStyles.amount),
          const SizedBox(height: AppSpacing.xs),
          Text(
            count == 1 ? '1 expense recorded' : '$count expenses recorded',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.budget,
    required this.spent,
    required this.onTap,
  });

  final double budget;
  final double spent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final remaining = budget - spent;
    final isOver = remaining < 0;
    final ratio = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    final percentUsed = budget <= 0 ? 0.0 : spent / budget;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Monthly budget', style: AppTextStyles.caption),
              const Spacer(),
              const Icon(
                Icons.edit_rounded,
                size: 15,
                color: AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(Formatters.peso(budget), style: AppTextStyles.h2),
          if (isOver) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.yellow24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: AppColors.charcoal,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Over budget by ${Formatters.peso(remaining.abs())}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.charcoal08,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? AppColors.yellow : AppColors.purple,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                isOver
                    ? 'Spent ${Formatters.peso(spent)}'
                    : '${Formatters.peso(remaining)} left',
                style: AppTextStyles.captionSmall,
              ),
              const Spacer(),
              Text(
                Formatters.percent(percentUsed),
                style: AppTextStyles.captionSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.totals});

  final Map<ExpenseCategory, double> totals;

  @override
  Widget build(BuildContext context) {
    if (totals.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            const Icon(
              Icons.pie_chart_outline_rounded,
              size: 20,
              color: AppColors.muted,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'No category totals yet — add an expense to see the breakdown.',
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      );
    }

    final entries = totals.entries.toList();
    final overall = entries.fold<double>(0, (sum, entry) => sum + entry.value);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  CategoryBadge(category: entries[i].key, size: 36),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      entries[i].key.label,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.peso(entries[i].value),
                        style: AppTextStyles.amountSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        overall == 0
                            ? '0%'
                            : Formatters.percent(entries[i].value / overall),
                        style: AppTextStyles.captionSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
