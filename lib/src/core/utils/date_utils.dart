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

  /// Checks if the [date] is in the future.
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Checks if the [date] is in the past.
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Checks if the [year] is a leap year.
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Returns the number of days between [a] and [b].
  ///
  /// The result is absolute (always positive).
  static int daysBetween(DateTime a, DateTime b) {
    final from = DateTime(a.year, a.month, a.day);
    final to = DateTime(b.year, b.month, b.day);
    return (to.difference(from).inHours / 24).round().abs();
  }

  /// Adds [days] to the given [date].
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Checks if the [date] represents today.
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Returns the number of days in the given [month] of the [year].
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      return isLeapYear(year) ? 29 : 28;
    }
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  /// Checks if the given [date] is the last day of its month.
  static bool isLastDayOfMonth(DateTime date) {
    final daysInCurrentMonth = getDaysInMonth(date.year, date.month);
    return date.day == daysInCurrentMonth;
  }
}
