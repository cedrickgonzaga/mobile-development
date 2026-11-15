import 'expense_category.dart';

/// A single expense record.
///
/// `id` is null until the row has been inserted, so the same class is used for
/// both "new" and "saved" expenses.
class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    required this.createdAt,
  });

  final int? id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String note;
  final DateTime createdAt;

  bool get hasNote => note.trim().isNotEmpty;

  /// Row representation. `id` is omitted on insert so SQLite assigns it.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'category': category.dbValue,
      'date': date.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      category: ExpenseCategory.fromDb(map['category'] as String?),
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      note: map['note'] as String? ?? '',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
