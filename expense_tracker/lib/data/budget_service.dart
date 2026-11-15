import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's monthly budget with SharedPreferences.
///
/// Small single values like this do not need a table of their own, which is a
/// good contrast to explain at the defense: SQLite for records, preferences for
/// settings.
class BudgetService {
  BudgetService._();

  static final BudgetService instance = BudgetService._();

  static const _key = 'monthly_budget';
  static const defaultMonthlyBudget = 10000.0;

  double _cached = defaultMonthlyBudget;
  bool _loaded = false;

  Future<double> getMonthlyBudget() async {
    if (_loaded) return _cached;
    final prefs = await SharedPreferences.getInstance();
    _cached = prefs.getDouble(_key) ?? defaultMonthlyBudget;
    _loaded = true;
    return _cached;
  }

  Future<void> setMonthlyBudget(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, amount);
    _cached = amount;
    _loaded = true;
  }
}
