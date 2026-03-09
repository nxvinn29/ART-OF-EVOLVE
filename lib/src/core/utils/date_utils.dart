import 'package:intl/intl.dart';

/// Utility class for date and time formatting and comparison.
/// Date utility functions for the Art of Evolve project.
///
/// This file contains common date manipulation and comparison methods.
class AppDateUtils {
  /// Formats the [date] to 'MMM d, yyyy' (e.g., Jan 1, 2024) or a custom [pattern].
  static String formatDate(DateTime date, {String pattern = 'MMM d, yyyy'}) {
    // Use the intl package for date formatting with the specified pattern
    return DateFormat(pattern).format(date);
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
    // Exact day comparison requires year, month, and day to match
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

  /// Checks if two dates represent the same time (hour, minute, second).
  static bool isSameTime(DateTime a, DateTime b) {
    return a.hour == b.hour && a.minute == b.minute && a.second == b.second;
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

  /// Returns the date of the same day in the next month.
  static DateTime getNextMonth(DateTime date) {
    var year = date.year;
    var month = date.month + 1;
    if (month > 12) {
      month = 1;
      year++;
    }
    final nextMonthDays = getDaysInMonth(year, month);
    final day = date.day > nextMonthDays ? nextMonthDays : date.day;
    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  /// Returns the date of the same day in the previous month.
  static DateTime getPreviousMonth(DateTime date) {
    var year = date.year;
    var month = date.month - 1;
    if (month < 1) {
      month = 12;
      year--;
    }
    final prevMonthDays = getDaysInMonth(year, month);
    final day = date.day > prevMonthDays ? prevMonthDays : date.day;
    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  /// Checks if two dates are in the same quarter of the year.
  static bool isSameQuarter(DateTime a, DateTime b) {
    return a.year == b.year && getQuarter(a) == getQuarter(b);
  }

  /// Returns the start of the year (January 1st) for the given [date].
  ///
  /// The returned date will have the time set to 00:00:00.
  static DateTime getStartOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Returns the end of the year (December 31st) for the given [date].
  static DateTime getEndOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Returns the earlier of two dates.
  static DateTime min(DateTime a, DateTime b) {
    return a.isBefore(b) ? a : b;
  }

  /// Returns the later of two dates.
  static DateTime max(DateTime a, DateTime b) {
    return a.isAfter(b) ? a : b;
  }

  /// Checks if two dates represent the same hour.
  static bool isSameHour(DateTime a, DateTime b) {
    return isSameDay(a, b) && a.hour == b.hour;
  }

  /// Returns the number of minutes between [a] and [b].
  ///
  /// The result is absolute (always positive).
  static int minutesBetween(DateTime a, DateTime b) {
    return a.difference(b).inMinutes.abs();
  }

  /// Checks if the given [date] is in the morning (6:00 AM - 11:59 AM).
  static bool isMorning(DateTime date) {
    return date.hour >= 6 && date.hour < 12;
  }

  /// Returns true if the time of the given [date] is between 12:00 PM and 5:59 PM.
  static bool isAfternoon(DateTime date) {
    // Commit 15/20: Refined isAfternoon check
    return date.hour >= 12 && date.hour < 18;
  }

  /// Checks if the given [date] is in the evening (6:00 PM - 11:59 PM).
  static bool isEvening(DateTime date) {
    return date.hour >= 18;
  }

  /// Returns a [DateTime] at the very beginning (00:00:00) of the given [date].
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of the day (23:59:59.999) for the given [date].
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Adds [years] to the given [date].
  static DateTime addYears(DateTime date, int years) {
    return DateTime(
      date.year + years,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
    );
  }

  /// Subtracts [years] from the given [date].
  static DateTime subtractYears(DateTime date, int years) {
    return DateTime(
      date.year - years,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
    );
  }

  /// Returns the number of months between [a] and [b].
  static int diffInMonths(DateTime a, DateTime b) {
    return (a.year - b.year).abs() * 12 + (a.month - b.month).abs();
  }

  /// Returns the start of the month (1st day at 00:00:00) for the given [date].
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Returns the end of the month (last day at 23:59:59.999) for the given [date].
  static DateTime getEndOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(milliseconds: 1));
  }

  /// Checks if the given [date] falls between [start] and [end] dates (inclusive).
  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
        (date.isBefore(end) || date.isAtSameMomentAs(end));
  }

  /// Adds [months] to the given [date].
  static DateTime addMonths(DateTime date, int months) {
    var year = date.year;
    var month = date.month + months;

    while (month > 12) {
      month -= 12;
      year++;
    }
    while (month < 1) {
      month += 12;
      year--;
    }

    final daysInMonth = getDaysInMonth(year, month);
    final day = date.day > daysInMonth ? daysInMonth : date.day;

    return DateTime(
      year,
      month,
      day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  /// Subtracts [months] from the given [date].
  static DateTime subtractMonths(DateTime date, int months) {
    return addMonths(date, -months);
  }

  /// Calculates the age based on the [birthDate] and the current date.
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Returns the astronomical season for the given [date].
  ///
  /// North hemisphere standard seasons:
  /// - Spring: March 20 - June 20
  /// - Summer: June 21 - September 21
  /// - Autumn: September 22 - December 20
  /// - Winter: December 21 - March 19
  static String getSeason(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 20) ||
        (month > 3 && month < 6) ||
        (month == 6 && day <= 20)) {
      return 'Spring';
    } else if ((month == 6 && day >= 21) ||
        (month > 6 && month < 9) ||
        (month == 9 && day <= 21)) {
      return 'Summer';
    } else if ((month == 9 && day >= 22) ||
        (month > 9 && month < 12) ||
        (month == 12 && day <= 20)) {
      return 'Autumn';
    } else {
      return 'Winter';
    }
  }

  /// Returns the number of days remaining in the year from the given [date].
  static int getDaysRemainingInYear(DateTime date) {
    final endOfYear = DateTime(date.year, 12, 31);
    final diff = endOfYear.difference(
      DateTime(date.year, date.month, date.day),
    );
    return diff.inDays;
  }

  /// Formats the [date] with an ordinal suffix for the day (e.g., Jan 1st, 2024).
  static String formatWithOrdinal(DateTime date) {
    final day = date.day;
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    final monthName = DateFormat('MMM').format(date);
    return '$monthName $day$suffix, ${date.year}';
  }

  /// Returns the next day for the given [date].
  static DateTime nextDay(DateTime date) {
    return date.add(const Duration(days: 1));
  }

  /// Returns the previous day for the given [date].
  static DateTime previousDay(DateTime date) {
    return date.subtract(const Duration(days: 1));
  }

  /// Returns the total number of days in the year of the given [date].
  static int getDaysInYear(DateTime date) {
    return isLeap(date) ? 366 : 365;
  }

  /// Returns the ISO-8601 week number for the given [date].
  static int getWeekNumber(DateTime date) {
    // Week number calculation based on ISO-8601
    final thursday = date.weekday >= DateTime.thursday
        ? date.subtract(Duration(days: date.weekday - DateTime.thursday))
        : date.add(Duration(days: DateTime.thursday - date.weekday));

    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final diffInDays = thursday.difference(firstDayOfYear).inDays;
    return (diffInDays / 7).floor() + 1;
  }
}
