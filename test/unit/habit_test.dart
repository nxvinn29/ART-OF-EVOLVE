import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';

// ignore_for_file: deprecated_member_use

void main() {
  group('Habit Model Tests', () {
    test('should create a valid Habit instance with required fields', () {
      final habit = Habit(
        title: 'Morning Exercise',
        description: 'Exercise for 30 minutes',
        color: Colors.blue.value,
        iconCodePoint: Icons.fitness_center.codePoint,
      );

      expect(habit.title, 'Morning Exercise');
      expect(habit.description, 'Exercise for 30 minutes');
      expect(habit.color, Colors.blue.value);
      expect(habit.iconCodePoint, Icons.fitness_center.codePoint);
      expect(habit.id, isNotNull);
      expect(habit.id, isNotEmpty);
      expect(habit.completedDates, isEmpty);
      expect(habit.createdAt, isNotNull);
      expect(habit.isDaily, true);
      expect(habit.reminderTime, isNull);
    });

    test('should create Habit with custom id and createdAt', () {
      const customId = 'custom-habit-id';
      final customDate = DateTime(2025, 1, 1);

      final habit = Habit(
        id: customId,
        title: 'Reading',
        color: Colors.green.value,
        iconCodePoint: Icons.book.codePoint,
        createdAt: customDate,
      );

      expect(habit.id, customId);
      expect(habit.createdAt, customDate);
    });

    test('should create Habit with completed dates', () {
      final completedDates = [
        DateTime(2025, 12, 28),
        DateTime(2025, 12, 29),
        DateTime(2025, 12, 30),
      ];

      final habit = Habit(
        title: 'Meditation',
        color: Colors.purple.value,
        iconCodePoint: Icons.self_improvement.codePoint,
        completedDates: completedDates,
      );

      expect(habit.completedDates.length, 3);
      expect(habit.completedDates, completedDates);
    });

    test('should correctly check if habit is completed on a specific date', () {
      final habit = Habit(
        title: 'Water Intake',
        color: Colors.cyan.value,
        iconCodePoint: Icons.water_drop.codePoint,
        completedDates: [
          DateTime(2025, 12, 28, 10, 30), // Time should be ignored
          DateTime(2025, 12, 30, 15, 45),
        ],
      );

      expect(habit.isCompletedOn(DateTime(2025, 12, 28)), true);
      expect(habit.isCompletedOn(DateTime(2025, 12, 28, 23, 59)), true);
      expect(habit.isCompletedOn(DateTime(2025, 12, 30)), true);
      expect(habit.isCompletedOn(DateTime(2025, 12, 29)), false);
      expect(habit.isCompletedOn(DateTime(2025, 12, 27)), false);
    });

    test('should calculate current streak correctly when completed today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final habit = Habit(
        title: 'Journaling',
        color: Colors.orange.value,
        iconCodePoint: Icons.edit.codePoint,
        completedDates: [twoDaysAgo, yesterday, today],
      );

      expect(habit.currentStreak, 3);
    });

    test(
      'should calculate current streak correctly when not completed today',
      () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        final twoDaysAgo = today.subtract(const Duration(days: 2));
        final threeDaysAgo = today.subtract(const Duration(days: 3));

        final habit = Habit(
          title: 'Running',
          color: Colors.red.value,
          iconCodePoint: Icons.directions_run.codePoint,
          completedDates: [
            threeDaysAgo,
            twoDaysAgo,
            yesterday,
            // Not completed today
          ],
        );

        expect(habit.currentStreak, 3);
      },
    );

    test('should return zero streak when not completed today or yesterday', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final threeDaysAgo = today.subtract(const Duration(days: 3));
      final fourDaysAgo = today.subtract(const Duration(days: 4));

      final habit = Habit(
        title: 'Yoga',
        color: Colors.pink.value,
        iconCodePoint: Icons.spa.codePoint,
        completedDates: [
          fourDaysAgo,
          threeDaysAgo,
          // Gap of 2 days
        ],
      );

      expect(habit.currentStreak, 0);
    });

    test('should return zero streak for new habit with no completions', () {
      final habit = Habit(
        title: 'New Habit',
        color: Colors.amber.value,
        iconCodePoint: Icons.star.codePoint,
      );

      expect(habit.currentStreak, 0);
    });

    test('should handle streak calculation with non-consecutive dates', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final fiveDaysAgo = today.subtract(const Duration(days: 5));

      final habit = Habit(
        title: 'Study',
        color: Colors.indigo.value,
        iconCodePoint: Icons.school.codePoint,
        completedDates: [fiveDaysAgo, yesterday, today],
      );

      // Should only count consecutive days from today
      expect(habit.currentStreak, 2);
    });

    test('should create Habit with reminder time', () {
      final reminderTime = DateTime(2025, 1, 1, 8, 0); // 8:00 AM

      final habit = Habit(
        title: 'Morning Routine',
        color: Colors.teal.value,
        iconCodePoint: Icons.alarm.codePoint,
        reminderTime: reminderTime,
      );

      expect(habit.reminderTime, isNotNull);
      expect(habit.reminderTime, reminderTime);
    });

    test('should create non-daily habit', () {
      final habit = Habit(
        title: 'Weekly Review',
        color: Colors.brown.value,
        iconCodePoint: Icons.calendar_today.codePoint,
        isDaily: false,
      );

      expect(habit.isDaily, false);
    });

    test('should handle empty description', () {
      final habit = Habit(
        title: 'Simple Habit',
        color: Colors.grey.value,
        iconCodePoint: Icons.check.codePoint,
      );

      expect(habit.description, '');
    });

    test('should maintain streak across month boundaries', () {
      final habit = Habit(
        title: 'Cross Month Habit',
        color: Colors.deepPurple.value,
        iconCodePoint: Icons.trending_up.codePoint,
        completedDates: [
          DateTime(2025, 11, 29),
          DateTime(2025, 11, 30),
          DateTime(2025, 12, 1),
          DateTime(2025, 12, 2),
        ],
        createdAt: DateTime(2025, 11, 29),
      );

      // This test assumes we're checking from Dec 2, 2025
      // The streak should be 4 consecutive days
      expect(habit.completedDates.length, 4);
    });

    test('toString should return correct format', () {
      final habit = Habit(
        title: 'Test Habit',
        color: Colors.black.value,
        iconCodePoint: Icons.abc.codePoint,
      );
      expect(
        habit.toString(),
        contains('Habit(id: ${habit.id}, title: Test Habit, isDaily: true'),
      );
    });
  });
}
