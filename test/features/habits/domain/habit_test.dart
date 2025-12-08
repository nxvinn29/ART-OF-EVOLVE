import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';

void main() {
  group('Habit Logic', () {
    test('isCompletedOn returns true for matching date', () {
      final date = DateTime(2023, 1, 1);
      final habit = Habit(
        title: 'Test',
        color: 0,
        iconCodePoint: 0,
        completedDates: [date],
      );

      expect(habit.isCompletedOn(DateTime(2023, 1, 1, 10, 0)), true);
    });

    test('isCompletedOn returns false for non-matching date', () {
      final habit = Habit(
        title: 'Test',
        color: 0,
        iconCodePoint: 0,
        completedDates: [DateTime(2023, 1, 1)],
      );

      expect(habit.isCompletedOn(DateTime(2023, 1, 2)), false);
    });

    test('currentStreak calculates correctly for continuous streak ending today', () {
      final today = DateTime.now(); // Mocking time is hard without clock, assuming test runs fast
      // Actually, Habit.currentStreak uses DateTime.now().
      // For pure unit testing, it's better if Habit took a 'now' parameter or we could mock it.
      // But let's assume standard behavior:
      
      final yesterday = today.subtract(const Duration(days: 1));
      final dayBefore = today.subtract(const Duration(days: 2));

      final habit = Habit(
        title: 'Streak Test',
        color: 0,
        iconCodePoint: 0,
        completedDates: [today, yesterday, dayBefore],
      );

      expect(habit.currentStreak, 3);
    });

    test('currentStreak calculates correctly for continuous streak ending yesterday', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final dayBefore = today.subtract(const Duration(days: 2));

      final habit = Habit(
        title: 'Streak Test 2',
        color: 0,
        iconCodePoint: 0,
        completedDates: [yesterday, dayBefore],
      );

      // Should be 2 because if not completed today, we check yesterday.
      expect(habit.currentStreak, 2); 
    });

    test('currentStreak resets if gap exists', () {
      final today = DateTime.now();
      final dayBefore = today.subtract(const Duration(days: 2)); // Gap of 1 day (yesterday missed)

      final habit = Habit(
        title: 'Gap Test',
        color: 0,
        iconCodePoint: 0,
        completedDates: [today, dayBefore],
      );

      expect(habit.currentStreak, 1); // Only today counts
    });
  });
}
