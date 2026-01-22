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

    group('isFuture', () {
      test('returns true for future date', () {
        final future = DateTime.now().add(const Duration(days: 1));
        expect(AppDateUtils.isFuture(future), true);
      });

      test('returns false for past date', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(AppDateUtils.isFuture(past), false);
      });
    });

    group('isPast', () {
      test('returns true for past date', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(AppDateUtils.isPast(past), true);
      });

      test('returns false for future date', () {
        final future = DateTime.now().add(const Duration(days: 1));
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
  });
}
