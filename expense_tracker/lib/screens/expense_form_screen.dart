import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/database_helper.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/category_badge.dart';

/// One screen for both Add and Edit. A null [expense] means "create new";
/// passing an expense switches it to edit mode with prefilled fields.
class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, this.expense});

  final Expense? expense;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;

  ExpenseCategory? _category;
  DateTime? _date;
  bool _saving = false;
  bool _categoryError = false;
  bool _submitted = false;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController = TextEditingController(text: expense?.title ?? '');
    _amountController = TextEditingController(
      text: expense == null ? '' : expense.amount.toStringAsFixed(2),
    );
    _dateController = TextEditingController(
      text: expense == null ? '' : Formatters.date(expense.date),
    );
    _noteController = TextEditingController(text: expense?.note ?? '');
    _category = expense?.category;
    _date = expense?.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now, // an expense cannot happen in the future
      helpText: 'When did you spend it?',
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _dateController.text = Formatters.date(picked);
    });
    // Clear a previous "choose a date" error straight away.
    if (_submitted) _formKey.currentState?.validate();
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    final formValid = _formKey.currentState?.validate() ?? false;
    final categoryMissing = _category == null;
    setState(() => _categoryError = categoryMissing);
    if (!formValid || categoryMissing) {
      // The inline errors say what to fix; a haptic confirms the tap.
      await HapticFeedback.mediumImpact();
      return;
    }

    setState(() => _saving = true);

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', ''),
    );
    final expense = Expense(
      id: widget.expense?.id,
      title: _titleController.text.trim(),
      amount: amount,
      category: _category!,
      date: _date!,
      note: _noteController.text.trim(),
      createdAt: widget.expense?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      await DatabaseHelper.instance.updateExpense(expense);
    } else {
      await DatabaseHelper.instance.insertExpense(expense);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit expense' : 'New expense'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                _isEditing
                    ? 'Update the details and save your changes.'
                    : 'Record what you spent. Only the title, amount, '
                        'category and date are required.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              TextFormField(
                key: const ValueKey('title_field'),
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Lunch at Jollibee',
                  counterText: '',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Enter a title';
                  if (text.length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Amount
              TextFormField(
                key: const ValueKey('amount_field'),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixText: '₱ ',
                ),
                validator: (value) {
                  final text = value?.trim().replaceAll(',', '') ?? '';
                  if (text.isEmpty) return 'Enter an amount';
                  final amount = double.tryParse(text);
                  if (amount == null) return 'Enter numbers only';
                  if (amount <= 0) return 'Amount must be greater than zero';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Category
              Text('Category', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final category in ExpenseCategory.values)
                    ChoiceChip(
                      avatar: CategoryBadge(category: category, size: 22),
                      label: Text(category.label),
                      selected: _category == category,
                      onSelected: (_) {
                        setState(() {
                          _category = category;
                          _categoryError = false;
                        });
                      },
                    ),
                ],
              ),
              if (_categoryError) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Choose a category',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Date
              TextFormField(
                key: const ValueKey('date_field'),
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select a date',
                  suffixIcon: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ),
                validator: (_) =>
                    _date == null ? 'Please choose a date' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Note
              TextFormField(
                key: const ValueKey('note_field'),
                controller: _noteController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Anything you want to remember',
                  alignLabelWithHint: true,
                  counterText: '',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(_isEditing ? 'Save changes' : 'Save expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
