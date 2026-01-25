import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';

void main() {
  group('Habit Model Tests', () {
    test('should initialize with correct values', () {
      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
      );

      expect(habit.title, 'Exercise');
      expect(habit.color, 0xFF42A5F5);
      expect(habit.iconCodePoint, 0xe190);
      expect(habit.completedDates, isEmpty);
      expect(habit.isDaily, isTrue);
    });

    test('isCompletedOn should return true for completed dates', () {
      final today = DateTime.now();
      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
        completedDates: [today],
      );

      expect(habit.isCompletedOn(today), isTrue);
      expect(habit.isCompletedOnDate(today), isTrue);
    });

    test('isCompletedOn should return false for incomplete dates', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
        completedDates: [today],
      );

      expect(habit.isCompletedOn(yesterday), isFalse);
    });

    test('isCompletedYesterday should return true if completed yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
        completedDates: [yesterday],
      );

      expect(habit.isCompletedYesterday, isTrue);
    });

    test('currentStreak should calculate correctly', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
        completedDates: [today, yesterday, twoDaysAgo],
      );

      expect(habit.currentStreak, 3);
    });

    test(
      'currentStreak should return 0 if not completed today or yesterday',
      () {
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
        final habit = Habit(
          title: 'Exercise',
          color: 0xFF42A5F5,
          iconCodePoint: 0xe190,
          completedDates: [threeDaysAgo],
        );

        expect(habit.currentStreak, 0);
      },
    );

    test('currentStreak should be 1 if only completed today', () {
      final today = DateTime.now();
      final habit = Habit(
        title: 'Exercise',
        color: 0xFF42A5F5,
        iconCodePoint: 0xe190,
        completedDates: [today],
      );

      expect(habit.currentStreak, 1);
    });

    test(
      'currentStreak should be valid if completed yesterday but not today',
      () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        final habit = Habit(
          title: 'Exercise',
          color: 0xFF42A5F5,
          iconCodePoint: 0xe190,
          completedDates: [yesterday, twoDaysAgo],
        );

        expect(habit.currentStreak, 2);
      },
    );
  });
}
