import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/page_routes.dart';
import '../widgets/app_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import 'expense_details_screen.dart';
import 'expense_form_screen.dart';

/// Expenses tab: every saved record, grouped by day, newest first.
class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  bool _loading = true;
  List<Expense> _expenses = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final expenses = await DatabaseHelper.instance.getAllExpenses();
    if (!mounted) return;
    setState(() {
      _expenses = expenses;
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
    await _load();
    if (!mounted) return;
    if (result == 'deleted') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted')),
      );
    }
  }

  /// Groups the flat list into `{ day: [expenses] }`, keeping the query order.
  Map<DateTime, List<Expense>> _groupByDay() {
    final groups = <DateTime, List<Expense>>{};
    for (final expense in _expenses) {
      final day = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      groups.putIfAbsent(day, () => []).add(expense);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final total = _expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final groups = _groupByDay();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense'),
      ),
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                color: AppColors.purple,
                backgroundColor: AppColors.white,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  children: [
                    Text('ALL RECORDS', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 6),
                    Text('Expenses', style: AppTextStyles.h1),
                    const SizedBox(height: 6),
                    Text(
                      _expenses.isEmpty
                          ? 'Nothing recorded yet.'
                          : '${_expenses.length} '
                              '${_expenses.length == 1 ? 'expense' : 'expenses'}'
                              ' · ${Formatters.peso(total)} total',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (_expenses.isEmpty)
                      AppCard(
                        child: EmptyState(
                          icon: Icons.receipt_long_rounded,
                          title: 'No expenses yet',
                          message:
                              'Tap "Add expense" to record your first one. '
                              'Everything is saved on this device.',
                          actionLabel: 'Add expense',
                          onAction: _openAdd,
                        ),
                      )
                    else
                      for (final entry in groups.entries) ...[
                        _DayGroup(
                          day: entry.key,
                          expenses: entry.value,
                          onTapExpense: _openDetails,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({
    required this.day,
    required this.expenses,
    required this.onTapExpense,
  });

  final DateTime day;
  final List<Expense> expenses;
  final ValueChanged<Expense> onTapExpense;

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: 4),
          child: Row(
            children: [
              Text(Formatters.dayHeader(day), style: AppTextStyles.eyebrow),
              const Spacer(),
              Text(Formatters.peso(total), style: AppTextStyles.captionSmall),
            ],
          ),
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < expenses.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                ExpenseTile(
                  expense: expenses[i],
                  onTap: () => onTapExpense(expenses[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
