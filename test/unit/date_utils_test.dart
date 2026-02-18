import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/date_utils.dart';

/// Unit tests for [AppDateUtils].
///
/// Tests date formatting, time formatting, and date comparison utilities.
void main() {
  group('AppDateUtils Tests', () {
    group('formatDate', () {
      test('formats date correctly in MMM d, yyyy format', () {
        final date = DateTime(2026, 1, 2);
        expect(AppDateUtils.formatDate(date), 'Jan 2, 2026');
      });

      test('formats different months correctly', () {
        expect(AppDateUtils.formatDate(DateTime(2026, 3, 15)), 'Mar 15, 2026');
        expect(AppDateUtils.formatDate(DateTime(2026, 6, 30)), 'Jun 30, 2026');
        expect(AppDateUtils.formatDate(DateTime(2026, 12, 25)), 'Dec 25, 2026');
      });

      test('handles single digit days', () {
        final date = DateTime(2026, 5, 5);
        expect(AppDateUtils.formatDate(date), 'May 5, 2026');
      });

      test('handles double digit days', () {
        final date = DateTime(2026, 5, 15);
        expect(AppDateUtils.formatDate(date), 'May 15, 2026');
      });

      test('handles different years', () {
        expect(AppDateUtils.formatDate(DateTime(2025, 1, 1)), 'Jan 1, 2025');
        expect(AppDateUtils.formatDate(DateTime(2027, 1, 1)), 'Jan 1, 2027');
      });

      test('ignores time component', () {
        final date1 = DateTime(2026, 1, 2, 10, 30);
        final date2 = DateTime(2026, 1, 2, 23, 59);
        expect(AppDateUtils.formatDate(date1), 'Jan 2, 2026');
        expect(AppDateUtils.formatDate(date2), 'Jan 2, 2026');
      });
    });

    group('formatTime', () {
      test('formats time correctly in h:mm a format', () {
        final time = DateTime(2026, 1, 2, 14, 30);
        expect(AppDateUtils.formatTime(time), '2:30 PM');
      });

      test('formats morning time correctly', () {
        final time = DateTime(2026, 1, 2, 9, 15);
        expect(AppDateUtils.formatTime(time), '9:15 AM');
      });

      test('formats afternoon time correctly', () {
        final time = DateTime(2026, 1, 2, 15, 45);
        expect(AppDateUtils.formatTime(time), '3:45 PM');
      });

      test('formats midnight correctly', () {
        final time = DateTime(2026, 1, 2, 0, 0);
        expect(AppDateUtils.formatTime(time), '12:00 AM');
      });

      test('formats noon correctly', () {
        final time = DateTime(2026, 1, 2, 12, 0);
        expect(AppDateUtils.formatTime(time), '12:00 PM');
      });

      test('formats single digit minutes with leading zero', () {
        final time = DateTime(2026, 1, 2, 10, 5);
        expect(AppDateUtils.formatTime(time), '10:05 AM');
      });

      test('ignores date component', () {
        final time1 = DateTime(2026, 1, 1, 10, 30);
        final time2 = DateTime(2025, 12, 31, 10, 30);
        expect(AppDateUtils.formatTime(time1), '10:30 AM');
        expect(AppDateUtils.formatTime(time2), '10:30 AM');
      });
    });

    group('formatDateTime', () {
      test('formats date and time correctly', () {
        final dateTime = DateTime(2026, 1, 2, 14, 30);
        expect(AppDateUtils.formatDateTime(dateTime), 'Jan 2, 2026 2:30 PM');
      });

      test('formats morning datetime correctly', () {
        final dateTime = DateTime(2026, 3, 15, 9, 15);
        expect(AppDateUtils.formatDateTime(dateTime), 'Mar 15, 2026 9:15 AM');
      });

      test('formats evening datetime correctly', () {
        final dateTime = DateTime(2026, 12, 25, 18, 45);
        expect(AppDateUtils.formatDateTime(dateTime), 'Dec 25, 2026 6:45 PM');
      });

      test('formats midnight datetime correctly', () {
        final dateTime = DateTime(2026, 1, 1, 0, 0);
        expect(AppDateUtils.formatDateTime(dateTime), 'Jan 1, 2026 12:00 AM');
      });

      test('formats noon datetime correctly', () {
        final dateTime = DateTime(2026, 6, 15, 12, 0);
        expect(AppDateUtils.formatDateTime(dateTime), 'Jun 15, 2026 12:00 PM');
      });
    });

    group('isSameDay', () {
      test('returns true for same date', () {
        final date1 = DateTime(2026, 1, 2);
        final date2 = DateTime(2026, 1, 2);
        expect(AppDateUtils.isSameDay(date1, date2), true);
      });

      test('returns true for same date with different times', () {
        final date1 = DateTime(2026, 1, 2, 10, 30);
        final date2 = DateTime(2026, 1, 2, 23, 59);
        expect(AppDateUtils.isSameDay(date1, date2), true);
      });

      test('returns false for different days', () {
        final date1 = DateTime(2026, 1, 2);
        final date2 = DateTime(2026, 1, 3);
        expect(AppDateUtils.isSameDay(date1, date2), false);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2026, 1, 15);
        final date2 = DateTime(2026, 2, 15);
        expect(AppDateUtils.isSameDay(date1, date2), false);
      });

      test('returns false for different years', () {
        final date1 = DateTime(2025, 1, 2);
        final date2 = DateTime(2026, 1, 2);
        expect(AppDateUtils.isSameDay(date1, date2), false);
      });

      test('handles edge case of last day of month', () {
        final date1 = DateTime(2026, 1, 31);
        final date2 = DateTime(2026, 2, 1);
        expect(AppDateUtils.isSameDay(date1, date2), false);
      });

      test('handles edge case of last day of year', () {
        final date1 = DateTime(2025, 12, 31);
        final date2 = DateTime(2026, 1, 1);
        expect(AppDateUtils.isSameDay(date1, date2), false);
      });

      test('handles leap year dates', () {
        final date1 = DateTime(2024, 2, 29);
        final date2 = DateTime(2024, 2, 29, 23, 59);
        expect(AppDateUtils.isSameDay(date1, date2), true);
      });

      test('compares dates with milliseconds', () {
        final date1 = DateTime(2026, 1, 2, 10, 30, 45, 123);
        final date2 = DateTime(2026, 1, 2, 15, 45, 30, 456);
        expect(AppDateUtils.isSameDay(date1, date2), true);
      });

      test('returns true for same day at start and end of day', () {
        final startOfDay = DateTime(2026, 2, 13, 0, 0, 0);
        final endOfDay = DateTime(2026, 2, 13, 23, 59, 59, 999);
        expect(AppDateUtils.isSameDay(startOfDay, endOfDay), true);
      });
    });

    group('getStartOfWeek', () {
      test('returns Monday for any day of the week', () {
        // Jan 1, 2024 is a Monday
        final monday = DateTime(2024, 1, 1);
        expect(AppDateUtils.getStartOfWeek(monday), DateTime(2024, 1, 1));

        final tuesday = DateTime(2024, 1, 2);
        expect(AppDateUtils.getStartOfWeek(tuesday), DateTime(2024, 1, 1));

        final sunday = DateTime(2024, 1, 7);
        expect(AppDateUtils.getStartOfWeek(sunday), DateTime(2024, 1, 1));
      });

      test('returns previous year date if week starts in previous year', () {
        // Jan 1, 2025 is a Wednesday. Week starts Dec 30, 2024 (Monday)
        final wednesday = DateTime(2025, 1, 1);
        expect(AppDateUtils.getStartOfWeek(wednesday), DateTime(2024, 12, 30));
      });
    });

    group('isSameWeek', () {
      test('returns true for dates in same week', () {
        final monday = DateTime(2024, 1, 1);
        final sunday = DateTime(2024, 1, 7);
        expect(AppDateUtils.isSameWeek(monday, sunday), true);
      });

      test('returns false for dates in different weeks', () {
        final sunday = DateTime(2024, 1, 7);
        final nextMonday = DateTime(2024, 1, 8);
        expect(AppDateUtils.isSameWeek(sunday, nextMonday), false);
      });
    });

    group('isSameMonth', () {
      test('returns true for same month and year', () {
        expect(
          AppDateUtils.isSameMonth(DateTime(2026, 1, 2), DateTime(2026, 1, 31)),
          true,
        );
      });

      test('returns false for different month same year', () {
        expect(
          AppDateUtils.isSameMonth(DateTime(2026, 1, 2), DateTime(2026, 2, 2)),
          false,
        );
      });

      test('returns false for same month different year', () {
        expect(
          AppDateUtils.isSameMonth(DateTime(2025, 1, 2), DateTime(2026, 1, 2)),
          false,
        );
      });
    });

    group('isSameYear', () {
      test('returns true for same year', () {
        expect(
          AppDateUtils.isSameYear(DateTime(2026, 1, 2), DateTime(2026, 12, 31)),
          true,
        );
      });

      test('returns false for different years', () {
        expect(
          AppDateUtils.isSameYear(DateTime(2025, 1, 2), DateTime(2026, 1, 2)),
          false,
        );
      });
    });

    group('isFuture', () {
      test('returns true for future date', () {
        final future = DateTime.now().add(const Duration(hours: 1));
        expect(AppDateUtils.isFuture(future), true);
      });

      test('returns false for past date', () {
        final past = DateTime.now().subtract(const Duration(hours: 1));
        expect(AppDateUtils.isFuture(past), false);
      });
    });

    group('isPast', () {
      test('returns true for past date', () {
        final past = DateTime.now().subtract(const Duration(hours: 1));
        expect(AppDateUtils.isPast(past), true);
      });

      test('returns false for future date', () {
        final future = DateTime.now().add(const Duration(hours: 1));
        expect(AppDateUtils.isPast(future), false);
      });
    });

    group('isLeapYear', () {
      test('returns true for leap years', () {
        expect(AppDateUtils.isLeapYear(2024), true);
        expect(AppDateUtils.isLeapYear(2000), true);
      });

      test('returns false for non-leap years', () {
        expect(AppDateUtils.isLeapYear(2023), false);
        expect(AppDateUtils.isLeapYear(1900), false);
      });
    });

    group('isLeap', () {
      test('returns true for dates in leap years', () {
        expect(AppDateUtils.isLeap(DateTime(2024, 1, 1)), true);
        expect(AppDateUtils.isLeap(DateTime(2000, 12, 31)), true);
      });

      test('returns false for dates in non-leap years', () {
        expect(AppDateUtils.isLeap(DateTime(2023, 5, 15)), false);
        expect(AppDateUtils.isLeap(DateTime(2100, 1, 1)), false);
      });
    });

    group('daysBetween', () {
      test('calculates correct difference within same month', () {
        final d1 = DateTime(2026, 1, 1);
        final d2 = DateTime(2026, 1, 5);
        expect(AppDateUtils.daysBetween(d1, d2), 4);
      });

      test('calculates correct difference across months', () {
        final d1 = DateTime(2026, 1, 31);
        final d2 = DateTime(2026, 2, 2);
        expect(AppDateUtils.daysBetween(d1, d2), 2);
      });

      test('returns absolute value', () {
        final d1 = DateTime(2026, 1, 5);
        final d2 = DateTime(2026, 1, 1);
        expect(AppDateUtils.daysBetween(d1, d2), 4);
      });
    });

    group('addDays', () {
      test('adds days correctly', () {
        final date = DateTime(2026, 1, 1);
        final result = AppDateUtils.addDays(date, 5);
        expect(result.day, 6);
        expect(result.month, 1);
      });

      test('adds days across months', () {
        final date = DateTime(2026, 1, 31);
        final result = AppDateUtils.addDays(date, 5);
        expect(result.day, 5);
        expect(result.month, 2);
      });
    });

    group('isToday', () {
      test('returns true for today', () {
        expect(AppDateUtils.isToday(DateTime.now()), true);
      });

      test('returns false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(AppDateUtils.isToday(tomorrow), false);
      });
    });

    group('isTomorrow', () {
      test('returns true for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(AppDateUtils.isTomorrow(tomorrow), true);
      });

      test('returns false for today', () {
        expect(AppDateUtils.isTomorrow(DateTime.now()), false);
      });

      test('returns false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(AppDateUtils.isTomorrow(yesterday), false);
      });
    });

    group('isYesterday', () {
      test('returns true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(AppDateUtils.isYesterday(yesterday), true);
      });

      test('returns false for today', () {
        expect(AppDateUtils.isYesterday(DateTime.now()), false);
      });

      test('returns false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(AppDateUtils.isYesterday(tomorrow), false);
      });
    });

    group('getDatesInWeek', () {
      test('returns 7 dates for a given week', () {
        final date = DateTime(2026, 1, 25); // Sunday
        final dates = AppDateUtils.getDatesInWeek(date);
        expect(dates.length, 7);
        // Jan 19 (Mon) to Jan 25 (Sun)
        expect(
          AppDateUtils.isSameDay(dates.first, DateTime(2026, 1, 19)),
          true,
        );
        expect(AppDateUtils.isSameDay(dates.last, DateTime(2026, 1, 25)), true);
      });

      test('returned dates are consecutive', () {
        final date = DateTime(2026, 1, 25);
        final dates = AppDateUtils.getDatesInWeek(date);
        for (var i = 0; i < 6; i++) {
          expect(dates[i + 1].difference(dates[i]).inDays, 1);
        }
      });
    });

    group('getDaysInMonth', () {
      test('returns 31 for January', () {
        expect(AppDateUtils.getDaysInMonth(2026, 1), 31);
      });

      test('returns 28 for February in non-leap year', () {
        expect(AppDateUtils.getDaysInMonth(2026, 2), 28);
      });

      test('returns 29 for February in leap year', () {
        expect(AppDateUtils.getDaysInMonth(2024, 2), 29);
      });

      test('returns 30 for April', () {
        expect(AppDateUtils.getDaysInMonth(2026, 4), 30);
      });

      test('returns 31 for December', () {
        expect(AppDateUtils.getDaysInMonth(2026, 12), 31);
      });
    });

    group('isLastDayOfMonth', () {
      test('returns true for Jan 31', () {
        expect(AppDateUtils.isLastDayOfMonth(DateTime(2026, 1, 31)), true);
      });

      test('returns true for Feb 28 in non-leap year', () {
        expect(AppDateUtils.isLastDayOfMonth(DateTime(2026, 2, 28)), true);
      });

      test('returns true for Feb 29 in leap year', () {
        expect(AppDateUtils.isLastDayOfMonth(DateTime(2024, 2, 29)), true);
      });

      test('returns false for Jan 30', () {
        expect(AppDateUtils.isLastDayOfMonth(DateTime(2026, 1, 30)), false);
      });

      test('returns false for Feb 1', () {
        expect(AppDateUtils.isLastDayOfMonth(DateTime(2026, 2, 1)), false);
      });
    });

    group('isFirstDayOfMonth', () {
      test('returns true for Jan 1', () {
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2026, 1, 1)), true);
      });

      test('returns true for Feb 1', () {
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2026, 2, 1)), true);
      });

      test('returns false for Jan 2', () {
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2026, 1, 2)), false);
      });

      test('returns false for Feb 28', () {
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2026, 2, 28)), false);
      });

      test('ignores year and month', () {
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2024, 5, 1)), true);
        expect(AppDateUtils.isFirstDayOfMonth(DateTime(2025, 12, 1)), true);
      });
    });

    group('Integration Tests', () {
      test('formats and compares current date', () {
        final now = DateTime.now();
        final formatted = AppDateUtils.formatDate(now);
        expect(formatted, isNotEmpty);
        expect(AppDateUtils.isSameDay(now, DateTime.now()), true);
      });

      test('formats complete datetime information', () {
        final dateTime = DateTime(2026, 6, 15, 14, 30);

        final date = AppDateUtils.formatDate(dateTime);
        final time = AppDateUtils.formatTime(dateTime);
        final combined = AppDateUtils.formatDateTime(dateTime);

        expect(date, 'Jun 15, 2026');
        expect(time, '2:30 PM');
        expect(combined, 'Jun 15, 2026 2:30 PM');
      });

      test('handles date comparison across different formats', () {
        final date1 = DateTime(2026, 1, 2, 10, 30);
        final date2 = DateTime(2026, 1, 2, 22, 45);
        final date3 = DateTime(2026, 1, 3, 10, 30);

        expect(AppDateUtils.isSameDay(date1, date2), true);
        expect(AppDateUtils.isSameDay(date1, date3), false);
        expect(AppDateUtils.formatDate(date1), AppDateUtils.formatDate(date2));
      });
    });
    group('getRelativeTime', () {
      test('returns "Just now" for seconds ago', () {
        final now = DateTime.now();
        final past = now.subtract(const Duration(seconds: 30));
        expect(AppDateUtils.getRelativeTime(past), 'Just now');
      });

      test('returns minutes ago', () {
        final now = DateTime.now();
        final past = now.subtract(const Duration(minutes: 5));
        expect(AppDateUtils.getRelativeTime(past), '5m ago');
      });

      test('returns hours ago', () {
        final now = DateTime.now();
        final past = now.subtract(const Duration(hours: 3));
        expect(AppDateUtils.getRelativeTime(past), '3h ago');
      });

      test('returns days ago', () {
        final now = DateTime.now();
        final past = now.subtract(const Duration(days: 2));
        expect(AppDateUtils.getRelativeTime(past), '2d ago');
      });

      test('returns formatted date for more than a week ago', () {
        final past = DateTime(2024, 1, 1);
        expect(
          AppDateUtils.getRelativeTime(past),
          AppDateUtils.formatDate(past),
        );
      });
    });

    group('isWeekend', () {
      test('returns true for Saturday', () {
        final saturday = DateTime(2026, 1, 31); // Saturday
        expect(AppDateUtils.isWeekend(saturday), true);
      });

      test('returns true for Sunday', () {
        final sunday = DateTime(2026, 2, 1); // Sunday
        expect(AppDateUtils.isWeekend(sunday), true);
      });

      test('returns false for Monday', () {
        final monday = DateTime(2026, 2, 2); // Monday
        expect(AppDateUtils.isWeekend(monday), false);
      });

      test('returns false for Wednesday', () {
        final wednesday = DateTime(2026, 2, 4); // Wednesday
        expect(AppDateUtils.isWeekend(wednesday), false);
      });
    });

    group('isSameTime', () {
      test('returns true for same time', () {
        final d1 = DateTime(2026, 1, 1, 10, 30, 45);
        final d2 = DateTime(2025, 12, 31, 10, 30, 45);
        expect(AppDateUtils.isSameTime(d1, d2), true);
      });

      test('returns false for different time', () {
        final d1 = DateTime(2026, 1, 1, 10, 30, 45);
        final d2 = DateTime(2026, 1, 1, 10, 30, 46);
        expect(AppDateUtils.isSameTime(d1, d2), false);
      });
    });

    group('getNextMonth', () {
      test('returns same day in next month', () {
        final date = DateTime(2026, 1, 15);
        final next = AppDateUtils.getNextMonth(date);
        expect(next.year, 2026);
        expect(next.month, 2);
        expect(next.day, 15);
      });

      test('handles year rollover', () {
        final date = DateTime(2025, 12, 10);
        final next = AppDateUtils.getNextMonth(date);
        expect(next.year, 2026);
        expect(next.month, 1);
      });

      test('handles shorter months', () {
        final date = DateTime(2026, 1, 31);
        final next = AppDateUtils.getNextMonth(date);
        expect(next.month, 2);
        expect(next.day, 28);
      });
    });

    group('getPreviousMonth', () {
      test('returns same day in previous month', () {
        final date = DateTime(2026, 2, 15);
        final prev = AppDateUtils.getPreviousMonth(date);
        expect(prev.year, 2026);
        expect(prev.month, 1);
        expect(prev.day, 15);
      });

      test('handles year rollover', () {
        final date = DateTime(2026, 1, 10);
        final prev = AppDateUtils.getPreviousMonth(date);
        expect(prev.year, 2025);
        expect(prev.month, 12);
      });

      test('handles shorter months', () {
        final date = DateTime(2026, 3, 31);
        final prev = AppDateUtils.getPreviousMonth(date);
        expect(prev.month, 2);
        expect(prev.day, 28);
      });
    });

    group('isSameQuarter', () {
      test('returns true for same quarter', () {
        expect(
          AppDateUtils.isSameQuarter(
            DateTime(2026, 1, 1),
            DateTime(2026, 3, 31),
          ),
          true,
        );
      });

      test('returns false for different quarters', () {
        expect(
          AppDateUtils.isSameQuarter(
            DateTime(2026, 3, 31),
            DateTime(2026, 4, 1),
          ),
          false,
        );
      });

      test('returns false for different years', () {
        expect(
          AppDateUtils.isSameQuarter(
            DateTime(2025, 1, 1),
            DateTime(2026, 1, 1),
          ),
          false,
        );
      });
    });

    group('getStartOfYear', () {
      test('returns Jan 1st of the same year', () {
        final date = DateTime(2026, 5, 15);
        final startOfYear = AppDateUtils.getStartOfYear(date);
        expect(startOfYear.year, 2026);
        expect(startOfYear.month, 1);
        expect(startOfYear.day, 1);
      });
    });

    group('getEndOfYear', () {
      test('returns Dec 31st of the same year', () {
        final date = DateTime(2026, 5, 15);
        final endOfYear = AppDateUtils.getEndOfYear(date);
        expect(endOfYear.year, 2026);
        expect(endOfYear.month, 12);
        expect(endOfYear.day, 31);
      });
    });

    group('min', () {
      test('returns earlier date', () {
        final d1 = DateTime(2026, 1, 1);
        final d2 = DateTime(2026, 1, 2);
        expect(AppDateUtils.min(d1, d2), d1);
        expect(AppDateUtils.min(d2, d1), d1);
      });
    });

    group('max', () {
      test('returns later date', () {
        final d1 = DateTime(2026, 1, 1);
        final d2 = DateTime(2026, 1, 2);
        expect(AppDateUtils.max(d1, d2), d2);
        expect(AppDateUtils.max(d2, d1), d2);
      });
    });
    test('isSameHour should work correctly', () {
      final date1 = DateTime(2023, 1, 1, 10, 0);
      final date2 = DateTime(2023, 1, 1, 10, 30);
      final date3 = DateTime(2023, 1, 1, 11, 0);
      final date4 = DateTime(2023, 1, 2, 10, 0);

      expect(AppDateUtils.isSameHour(date1, date2), true);
      expect(AppDateUtils.isSameHour(date1, date3), false);
      expect(AppDateUtils.isSameHour(date1, date4), false);
    });
    test('minutesBetween should return absolute minutes', () {
      final date1 = DateTime(2023, 1, 1, 10, 0);
      final date2 = DateTime(2023, 1, 1, 10, 30);
      final date3 = DateTime(2023, 1, 1, 10, 15);

      expect(AppDateUtils.minutesBetween(date1, date2), 30);
      expect(AppDateUtils.minutesBetween(date2, date1), 30);
      expect(AppDateUtils.minutesBetween(date1, date3), 15);
      expect(AppDateUtils.minutesBetween(date1, date1), 0);
    });
    test('isMorning should detect morning times correctly', () {
      expect(AppDateUtils.isMorning(DateTime(2023, 1, 1, 6, 0)), true);
      expect(AppDateUtils.isMorning(DateTime(2023, 1, 1, 11, 59)), true);
      expect(AppDateUtils.isMorning(DateTime(2023, 1, 1, 5, 59)), false);
      expect(AppDateUtils.isMorning(DateTime(2023, 1, 1, 12, 0)), false);
    });
    test('isAfternoon should detect afternoon times correctly', () {
      expect(AppDateUtils.isAfternoon(DateTime(2023, 1, 1, 12, 0)), true);
      expect(AppDateUtils.isAfternoon(DateTime(2023, 1, 1, 17, 59)), true);
      expect(AppDateUtils.isAfternoon(DateTime(2023, 1, 1, 11, 59)), false);
      expect(AppDateUtils.isAfternoon(DateTime(2023, 1, 1, 18, 0)), false);
    });
  });
}
