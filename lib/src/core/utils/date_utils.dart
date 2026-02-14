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

  /// Checks if two dates fall within the same month.
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  /// Checks if two dates fall within the same year.
  static bool isSameYear(DateTime a, DateTime b) {
    return a.year == b.year;
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

  /// Checks if the [date] falls in a leap year.
  static bool isLeap(DateTime date) {
    return isLeapYear(date.year);
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

  /// Checks if the [date] represents yesterday.
  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Checks if the [date] represents tomorrow.
  static bool isTomorrow(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Returns a list of all dates in the week containing the given [date].
  ///
  /// The week is assumed to start on Monday.
  static List<DateTime> getDatesInWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
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

  /// Checks if the given [date] is the first day of its month.
  static bool isFirstDayOfMonth(DateTime date) {
    return date.day == 1;
  }

  /// Returns a human-readable relative time string.
  ///
  /// Example: "Just now", "5m ago", "2h ago", "3d ago".
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }

  /// Checks if the given [date] falls on a weekend (Saturday or Sunday).
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Checks if the given [date] falls on a weekday (Monday to Friday).
  static bool isWeekday(DateTime date) {
    return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
  }

  /// Returns the quarter of the year for the given [date] (1 to 4).
  static int getQuarter(DateTime date) {
    return (date.month - 1) ~/ 3 + 1;
  }
}
