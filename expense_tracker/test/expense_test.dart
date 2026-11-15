import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/screens/expense_form_screen.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Expense model', () {
    test('toMap -> fromMap keeps every field', () {
      final expense = Expense(
        id: 7,
        title: 'Lunch',
        amount: 250.75,
        category: ExpenseCategory.food,
        date: DateTime(2026, 11, 15),
        note: 'With the team',
        createdAt: DateTime(2026, 11, 15, 12, 30),
      );

      final restored = Expense.fromMap(expense.toMap());

      expect(restored.id, 7);
      expect(restored.title, 'Lunch');
      expect(restored.amount, 250.75);
      expect(restored.category, ExpenseCategory.food);
      expect(restored.date, DateTime(2026, 11, 15));
      expect(restored.note, 'With the team');
      expect(restored.createdAt, DateTime(2026, 11, 15, 12, 30));
    });

    test('a new expense has no id, so SQLite assigns one', () {
      final expense = Expense(
        title: 'Bus fare',
        amount: 15,
        category: ExpenseCategory.transport,
        date: DateTime(2026, 11, 15),
        createdAt: DateTime(2026, 11, 15),
      );

      expect(expense.toMap().containsKey('id'), isFalse);
    });

    test('an unknown category falls back to "Others"', () {
      expect(ExpenseCategory.fromDb('gadgets'), ExpenseCategory.others);
      expect(ExpenseCategory.fromDb(null), ExpenseCategory.others);
    });

    test('copyWith keeps fields that are not passed', () {
      final expense = Expense(
        id: 1,
        title: 'Coffee',
        amount: 120,
        category: ExpenseCategory.food,
        date: DateTime(2026, 11, 15),
        createdAt: DateTime(2026, 11, 15),
      );

      final updated = expense.copyWith(amount: 150);

      expect(updated.id, 1);
      expect(updated.amount, 150);
      expect(updated.title, 'Coffee');
    });
  });

  group('Expense form validation', () {
    Future<void> pumpForm(WidgetTester tester) async {
      // A tall surface keeps the whole form (and its Save button) on screen.
      tester.view.physicalSize = const Size(500, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const ExpenseFormScreen()),
      );
    }

    testWidgets('flags every required field when saving an empty form',
        (tester) async {
      await pumpForm(tester);

      await tester.tap(find.text('Save expense'));
      await tester.pump();

      expect(find.text('Enter a title'), findsOneWidget);
      expect(find.text('Enter an amount'), findsOneWidget);
      expect(find.text('Choose a category'), findsOneWidget);
      expect(find.text('Please choose a date'), findsOneWidget);
    });

    testWidgets('rejects an amount of zero', (tester) async {
      await pumpForm(tester);

      await tester.enterText(find.byType(TextFormField).at(1), '0');
      await tester.tap(find.text('Save expense'));
      await tester.pump();

      expect(find.text('Amount must be greater than zero'), findsOneWidget);
    });
  });
}
