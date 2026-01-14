import 'package:intl/intl.dart';

/// Utility class for date and time formatting and comparison.
class AppDateUtils {
  /// Formats the [date] to 'MMM d, yyyy' (e.g., Jan 1, 2024).
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Formats the [date] time to 'h:mm a' (e.g., 5:30 PM).
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Formats the [date] to 'MMM d, yyyy h:mm a'.
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  /// Checks if two dates represent the same day.
  ///
  /// Ignores time components.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns the start of the week (Monday) for the given [date].
  ///
  /// The returned date will have the time set to 00:00:00.
  static DateTime getStartOfWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  /// Checks if two dates fall within the same week.
  ///
  /// Weeks are assumed to start on Monday.
  static bool isSameWeek(DateTime a, DateTime b) {
    return isSameDay(getStartOfWeek(a), getStartOfWeek(b));
  }
}
