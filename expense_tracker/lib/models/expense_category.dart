/// The seven fixed categories an expense can belong to.
///
/// Stored in SQLite as the enum `name` (`food`, `transport`, ...), so renaming a
/// label never breaks existing rows.
enum ExpenseCategory {
  food('Food', 'food'),
  transport('Transport', 'transport'),
  bills('Bills', 'bills'),
  shopping('Shopping', 'shopping'),
  health('Health', 'health'),
  entertainment('Entertainment', 'entertainment'),
  others('Others', 'others');

  const ExpenseCategory(this.label, this.dbValue);

  final String label;
  final String dbValue;

  /// Tolerates rows written by an older build or manual edits.
  static ExpenseCategory fromDb(String? value) {
    for (final category in ExpenseCategory.values) {
      if (category.dbValue == value) return category;
    }
    return ExpenseCategory.others;
  }
}
