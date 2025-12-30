import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// Helper functions for date and time operations in tests
class DateTimeHelpers {
  /// Formats a DateTime to a readable string (e.g., "Dec 30, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// Formats a DateTime to show time only (e.g., "2:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Formats a DateTime to show both date and time (e.g., "Dec 30, 2025 at 2:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(date);
  }

  /// Checks if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Gets the start of day (midnight) for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end of day (23:59:59) for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Calculates the number of days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = startOfDay(from);
    final toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }

  /// Gets the start of the current week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return startOfDay(monday);
  }

  /// Gets the end of the current week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final sunday = date.add(Duration(days: 7 - date.weekday));
    return endOfDay(sunday);
  }

  /// Checks if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Checks if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Gets a list of dates for the past N days
  static List<DateTime> getPastDays(int count) {
    final today = startOfDay(DateTime.now());
    return List.generate(count, (index) {
      return today.subtract(Duration(days: index));
    });
  }
}

void main() {
  group('DateTimeHelpers Tests', () {
    test('should format date correctly', () {
      final date = DateTime(2025, 12, 30);
      expect(DateTimeHelpers.formatDate(date), 'Dec 30, 2025');
    });

    test('should format time correctly', () {
      final date = DateTime(2025, 12, 30, 14, 30);
      expect(DateTimeHelpers.formatTime(date), '2:30 PM');
    });

    test('should format datetime correctly', () {
      final date = DateTime(2025, 12, 30, 14, 30);
      expect(DateTimeHelpers.formatDateTime(date), 'Dec 30, 2025 at 2:30 PM');
    });

    test('should correctly identify same day', () {
      final date1 = DateTime(2025, 12, 30, 10, 0);
      final date2 = DateTime(2025, 12, 30, 15, 30);
      expect(DateTimeHelpers.isSameDay(date1, date2), true);
    });

    test('should correctly identify different days', () {
      final date1 = DateTime(2025, 12, 30);
      final date2 = DateTime(2025, 12, 31);
      expect(DateTimeHelpers.isSameDay(date1, date2), false);
    });

    test('should get start of day', () {
      final date = DateTime(2025, 12, 30, 15, 30, 45);
      final startOfDay = DateTimeHelpers.startOfDay(date);
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);
    });

    test('should get end of day', () {
      final date = DateTime(2025, 12, 30, 10, 0);
      final endOfDay = DateTimeHelpers.endOfDay(date);
      expect(endOfDay.hour, 23);
      expect(endOfDay.minute, 59);
      expect(endOfDay.second, 59);
    });

    test('should calculate days between dates', () {
      final from = DateTime(2025, 12, 25);
      final to = DateTime(2025, 12, 30);
      expect(DateTimeHelpers.daysBetween(from, to), 5);
    });

    test('should get start of week (Monday)', () {
      final tuesday = DateTime(2025, 12, 30); // Tuesday
      final monday = DateTimeHelpers.startOfWeek(tuesday);
      expect(monday.weekday, DateTime.monday);
      expect(monday.day, 29);
    });

    test('should get end of week (Sunday)', () {
      final tuesday = DateTime(2025, 12, 30); // Tuesday
      final sunday = DateTimeHelpers.endOfWeek(tuesday);
      expect(sunday.weekday, DateTime.sunday);
      expect(sunday.day, 4); // Jan 4, 2026
    });

    test('should identify today correctly', () {
      final today = DateTime.now();
      expect(DateTimeHelpers.isToday(today), true);
    });

    test('should identify yesterday correctly', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(DateTimeHelpers.isYesterday(yesterday), true);
    });

    test('should generate past days list', () {
      final pastDays = DateTimeHelpers.getPastDays(7);
      expect(pastDays.length, 7);
      expect(DateTimeHelpers.isToday(pastDays[0]), true);
    });

    test('should handle month boundaries in daysBetween', () {
      final from = DateTime(2025, 11, 28);
      final to = DateTime(2025, 12, 2);
      expect(DateTimeHelpers.daysBetween(from, to), 4);
    });

    test('should handle year boundaries in daysBetween', () {
      final from = DateTime(2025, 12, 30);
      final to = DateTime(2026, 1, 2);
      expect(DateTimeHelpers.daysBetween(from, to), 3);
    });
  });
}
