# Defense notes — Spendly

Fifteen questions an instructor is likely to ask, answered from this codebase.
Line references are to the files in `expense_tracker/lib/`.

---

## 1. Why SQLite instead of SharedPreferences for the expenses?

SharedPreferences only stores flat key/value pairs. Expenses are a growing list
of records with several fields that we need to sort, group and sum (`SUM(amount)
WHERE date >= ? AND date < ?`). A table gives us that for free, plus a `CHECK
(amount > 0)` constraint. SharedPreferences is still used for the one setting
that is a single value: the monthly budget (`data/budget_service.dart`).

## 2. Walk through the database schema.

`data/database_helper.dart` → `_createSchema`:

```sql
CREATE TABLE expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  amount REAL NOT NULL CHECK (amount > 0),
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  note TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL
);
CREATE INDEX idx_expenses_date ON expenses(date);
```

Dates are stored as ISO-8601 strings (`2026-11-15T00:00:00.000`). That format
sorts correctly as plain text and makes range queries readable. The index on
`date` keeps the monthly queries fast as the table grows.

## 3. Why is `DatabaseHelper` a singleton?

Opening a SQLite database is expensive, and two connections to the same file can
lock each other. `DatabaseHelper._()` is a private constructor and
`instance` is the only instance, so `database` opens once and is reused
(`_db ??= await _open()`).

## 4. How does the monthly total work, and why a half-open range?

`totalForMonth` builds `start = first day of month` and `end = first day of the
next month`, then queries `date >= start AND date < end`. This is a half-open
range: it includes every second of the last day and works for December
(`DateTime(year, 13, 1)` rolls over to January of the next year). A
`LIKE '2026-11%'` query would work too, but it is slower and would match
`2026-11` inside other text.

## 5. How is one screen used for both Add and Edit?

`ExpenseFormScreen({this.expense})`. When `expense` is null the screen is in
create mode; when it is passed, `initState` prefills the controllers and
`_isEditing` switches the title and the button label. `_save` calls
`updateExpense` if `widget.expense?.id != null`, otherwise `insertExpense`. One
form means validation and layout can never drift between the two flows.

## 6. How is form validation implemented?

`Form` + `GlobalKey<FormState>` in `expense_form_screen.dart`. `_save` calls
`_formKey.currentState!.validate()`, which runs every field's `validator` and
shows `errorText` inline. Rules: title required and at least 3 characters,
amount required, numeric and `> 0`, category required (tracked in `_category`
with its own inline error), date required. The amount field also has
`FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))` so letters cannot be
typed at all, and `TextInputType.numberWithOptions(decimal: true)` shows a
numeric keyboard.

## 7. Why is the date field a read-only `TextFormField` and not a `FormField`?

It was originally a custom `FormField<DateTime>` with an `InputDecorator`. It
looked right, but `Form.validate()` did not surface its error on the screen —
the date field silently stayed valid. Replacing it with:

```dart
TextFormField(
  controller: _dateController,
  readOnly: true,
  onTap: _pickDate,
  validator: (_) => _date == null ? 'Please choose a date' : null,
)
```

made it a normal `FormField<String>` that the `Form` manages, so validation
errors appear reliably. The controller holds the formatted date
(`Nov 15, 2026`) and `_date` holds the real `DateTime` we save.

## 8. Why do the form fields have `ValueKey`s?

While debugging the date bug, two otherwise identical `TextFormField`s were
being reused by the element tree and the error state was not sticking to the
right field. Explicit `ValueKey('title_field')`, `'amount_field'`,
`'date_field'`, `'note_field'` give each field a stable identity. Widget tests
also become clearer because a field can be found by key.

## 9. How does the UI refresh after add / edit / delete?

The form only writes to SQLite and pops with a result:
`Navigator.pop(true)`. The caller (`HomeScreen._openAdd`,
`ExpenseListScreen._openAdd`, `ExpenseDetailsScreen._edit`) awaits the result
and calls `_load()` to re-read from the database. Details pops with the string
`'deleted'` after a confirmed delete; Home and List then show the "Expense
deleted" SnackBar. Re-reading instead of mutating a local list means the totals
can never drift from the database.

## 10. Is there any risk of `setState` after the widget is gone?

Every `await` is followed by `if (!mounted) return;` before `setState`
(`home_screen.dart`, `expense_list_screen.dart`,
`expense_details_screen.dart`). A user can navigate away while a query is
running; this guard prevents "setState() called after dispose()".

## 11. What was the `TextEditingController` crash and how was it fixed?

The budget dialog used to be built inline in `HomeScreen._editBudget`, with the
controller disposed right after `showDialog` returned. The dialog's exit
animation was still running and still using the controller, which produced
"A TextEditingController was used after being disposed" and then
`'_dependents.isEmpty': is not true`. The fix was to extract
`widgets/budget_dialog.dart` as a `StatefulWidget`: the dialog owns its
controller and disposes it in `dispose()`, which Flutter calls after the route
is removed.

## 12. How are categories stored and displayed?

`models/expense_category.dart` is an enum of the seven fixed categories, each
with a `label` (shown in the UI) and a `dbValue` (stored in SQLite). We store
`dbValue`, not `index`, so reordering the enum or renaming a label never breaks
saved rows. `fromDb` falls back to `others` for unknown values.
`utils/category_visuals.dart` is an extension that maps each category to an
icon and an accent colour; it lives outside `models/` so the model stays free of
Flutter widgets.

## 13. How is money formatted?

`intl`'s `NumberFormat.currency(locale: 'en_US', symbol: '₱ ', decimalDigits: 2)`
in `utils/formatters.dart`, used by every screen. Amount styles use
`FontFeature.tabularFigures()` so digits have equal width and columns do not
jitter when values change.

## 14. Where is the conditional logic the project requires?

- **Over-budget warning:** `_BudgetCard` compares `spent` to `budget`, shows a
  yellow warning chip and switches the progress bar colour when spent exceeds
  the budget.
- **Empty states:** Home and List show `EmptyState` cards when there are no
  rows; Home's category card explains there is no breakdown yet.
- **Grouping:** the List screen groups expenses by day in Dart
  (`_groupByDay`), computes a per-day total, and labels the header
  Today / Yesterday / weekday.
- **Singular/plural text:** "1 expense recorded" vs "3 expenses recorded".

## 15. What would you add next, and where would it go?

- **Search and category filter:** `DatabaseHelper.getAllExpenses` would take
  optional `where`/`whereArgs`; the List screen would own the filter state.
- **Charts:** a `fl_chart` bar/pie fed by the existing
  `categoryTotalsForMonth`; no schema change needed.
- **Schema migration:** bump `_version` and implement `onUpgrade` in
  `database_helper.dart` (for example adding a `currency` column).
- **Cloud sync/export:** export rows to CSV from `getAllExpenses`; SQLite stays
  the source of truth.

---

## Demo script (5 minutes)

1. Cold start → Splash → Home. Point out the month, greeting and budget card.
2. Add an expense: leave everything empty and tap Save → four inline errors.
3. Fill it in (title, amount, category, date via the calendar) → save → Home
   total, category breakdown and recent list update, SnackBar confirms.
4. Drag down to refresh; kill and relaunch the app to prove persistence
   (SQLite file on the device).
5. Open the expense → Details → Edit, change the amount → Save → details update.
6. Tap the budget card, set a small budget → Home shows "Over budget" in yellow.
7. Delete the expense → confirm dialog → list becomes empty state.
8. About tab → team and privacy note.

## If asked "what did AI do?"

Be direct: the agent scaffolded the code from the plan, and the team reviewed
each file, fixed the real bugs found while testing (date validation, the budget
controller crash, SnackBar/FAB overlap), and can explain every file listed in
the README structure. Then answer questions by pointing at the actual code.

## Files each member should be able to explain

| Member | Role (PDF §VII) | Files |
| --- | --- | --- |
| Gonzaga, Cedrick | Project Leader | `data/database_helper.dart`, `data/budget_service.dart`, `models/*` |
| De Chavez, Gerard Cyr | UI/UX Designer | `theme/*`, `screens/home_screen.dart`, `screens/expense_list_screen.dart`, `widgets/*` |
| Dungo, Mitch | Frontend Developer | `screens/splash_screen.dart`, `screens/main_shell.dart`, `screens/expense_form_screen.dart`, `screens/expense_details_screen.dart`, `utils/page_routes.dart` |
| Ramirez, Jay Darrius | Navigation Developer | `screens/main_shell.dart`, `utils/page_routes.dart`, `screens/splash_screen.dart` |
| Bernales, Remier Marc | Backend/Data Developer | `data/database_helper.dart`, `data/budget_service.dart`, `models/expense.dart` |
| Melia, Juleto Jaycee | Functionality and Testing; Documentation and QA | `test/expense_test.dart`, `utils/formatters.dart`, `screens/about_screen.dart`, `docs/` |
