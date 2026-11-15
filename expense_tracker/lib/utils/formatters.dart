import 'package:intl/intl.dart';

/// One place for every number and date the UI shows, so formatting stays
/// consistent between Home, List and Details.
class Formatters {
  Formatters._();

  static final NumberFormat _money = NumberFormat.currency(
    locale: 'en_US',
    symbol: '₱ ',
    decimalDigits: 2,
  );

  static final NumberFormat _plain = NumberFormat('#,##0.00', 'en_US');

  /// `₱ 1,250.00`
  static String peso(num amount) => _money.format(amount);

  /// `1,250.00` — for inputs where the currency symbol is separate.
  static String amount(num amount) => _plain.format(amount);

  /// `Nov 15, 2026`
  static String date(DateTime value) => DateFormat('MMM d, yyyy').format(value);

  /// `Saturday, November 15, 2026`
  static String fullDate(DateTime value) =>
      DateFormat('EEEE, MMMM d, yyyy').format(value);

  /// `November 2026`
  static String monthYear(DateTime value) =>
      DateFormat('MMMM yyyy').format(value);

  /// `75%`
  static String percent(double fraction) => '${(fraction * 100).round()}%';

  /// Group header for the list: Today / Yesterday / Saturday, Nov 15.
  static String dayHeader(DateTime value) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(value.year, value.month, value.day);
    final difference = today.difference(target).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (value.year == now.year) {
      return DateFormat('EEEE, MMM d').format(value);
    }
    return DateFormat('MMM d, yyyy').format(value);
  }

  /// Time-of-day greeting for the Home header.
  static String greeting([DateTime? at]) {
    final hour = (at ?? DateTime.now()).hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}
