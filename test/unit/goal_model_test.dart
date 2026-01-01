import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';

/// Unit tests for the [Goal] model.
///
/// Tests goal creation, validation, progress tracking, and data manipulation.
void main() {
  group('Goal Model Tests', () {
    test('creates goal with all required fields', () {
      final targetDate = DateTime(2026, 12, 31);
      final goal = Goal(
        title: 'Learn Flutter',
        description: 'Complete advanced Flutter course',
        targetDate: targetDate,
      );

      expect(goal.title, 'Learn Flutter');
      expect(goal.description, 'Complete advanced Flutter course');
      expect(goal.targetDate, targetDate);
      expect(goal.isAchieved, false);
      expect(goal.id, isNotEmpty);
      expect(goal.createdAt, isNotNull);
    });

    test('creates goal with custom id', () {
      const customId = 'custom-goal-id-123';
      final goal = Goal(
        id: customId,
        title: 'Custom Goal',
        targetDate: DateTime.now(),
      );

      expect(goal.id, customId);
    });

    test('creates goal with default description', () {
      final goal = Goal(title: 'Simple Goal', targetDate: DateTime.now());

      expect(goal.description, '');
    });

    test('creates goal with custom createdAt date', () {
      final customDate = DateTime(2026, 1, 1);
      final goal = Goal(
        title: 'Test Goal',
        targetDate: DateTime.now(),
        createdAt: customDate,
      );

      expect(goal.createdAt, customDate);
    });

    test('creates achieved goal', () {
      final goal = Goal(
        title: 'Completed Goal',
        targetDate: DateTime.now(),
        isAchieved: true,
      );

      expect(goal.isAchieved, true);
    });

    test('copyWith updates title', () {
      final original = Goal(
        title: 'Original Title',
        targetDate: DateTime.now(),
      );

      final updated = original.copyWith(title: 'Updated Title');

      expect(updated.title, 'Updated Title');
      expect(updated.id, original.id);
      expect(updated.targetDate, original.targetDate);
      expect(updated.createdAt, original.createdAt);
    });

    test('copyWith updates description', () {
      final original = Goal(
        title: 'Test Goal',
        description: 'Original description',
        targetDate: DateTime.now(),
      );

      final updated = original.copyWith(description: 'New description');

      expect(updated.description, 'New description');
      expect(updated.title, original.title);
    });

    test('copyWith updates targetDate', () {
      final originalDate = DateTime(2026, 6, 1);
      final newDate = DateTime(2026, 12, 31);

      final original = Goal(title: 'Test Goal', targetDate: originalDate);

      final updated = original.copyWith(targetDate: newDate);

      expect(updated.targetDate, newDate);
      expect(updated.title, original.title);
    });

    test('copyWith updates isAchieved', () {
      final original = Goal(
        title: 'Test Goal',
        targetDate: DateTime.now(),
        isAchieved: false,
      );

      final updated = original.copyWith(isAchieved: true);

      expect(updated.isAchieved, true);
      expect(original.isAchieved, false);
    });

    test('copyWith preserves unchanged fields', () {
      final original = Goal(
        title: 'Test Goal',
        description: 'Test description',
        targetDate: DateTime(2026, 12, 31),
        isAchieved: false,
      );

      final updated = original.copyWith(title: 'New Title');

      expect(updated.title, 'New Title');
      expect(updated.description, original.description);
      expect(updated.targetDate, original.targetDate);
      expect(updated.isAchieved, original.isAchieved);
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
    });

    test('generates unique ids for different goals', () {
      final goal1 = Goal(title: 'Goal 1', targetDate: DateTime.now());

      final goal2 = Goal(title: 'Goal 2', targetDate: DateTime.now());

      expect(goal1.id, isNot(equals(goal2.id)));
    });

    test('target date can be in the past', () {
      final pastDate = DateTime(2020, 1, 1);
      final goal = Goal(title: 'Past Goal', targetDate: pastDate);

      expect(goal.targetDate, pastDate);
    });

    test('target date can be in the future', () {
      final futureDate = DateTime(2030, 12, 31);
      final goal = Goal(title: 'Future Goal', targetDate: futureDate);

      expect(goal.targetDate, futureDate);
    });

    test('copyWith with no parameters returns equivalent goal', () {
      final original = Goal(
        title: 'Test Goal',
        description: 'Description',
        targetDate: DateTime(2026, 12, 31),
        isAchieved: true,
      );

      final copy = original.copyWith();

      expect(copy.title, original.title);
      expect(copy.description, original.description);
      expect(copy.targetDate, original.targetDate);
      expect(copy.isAchieved, original.isAchieved);
      expect(copy.id, original.id);
      expect(copy.createdAt, original.createdAt);
    });

    test('can mark unachieved goal as achieved', () {
      final goal = Goal(
        title: 'In Progress Goal',
        targetDate: DateTime.now(),
        isAchieved: false,
      );

      final achieved = goal.copyWith(isAchieved: true);

      expect(goal.isAchieved, false);
      expect(achieved.isAchieved, true);
    });

    test('can mark achieved goal as unachieved', () {
      final goal = Goal(
        title: 'Completed Goal',
        targetDate: DateTime.now(),
        isAchieved: true,
      );

      final unachieved = goal.copyWith(isAchieved: false);

      expect(goal.isAchieved, true);
      expect(unachieved.isAchieved, false);
    });

    test('createdAt is set to current time when not provided', () {
      final beforeCreation = DateTime.now();
      final goal = Goal(title: 'Test Goal', targetDate: DateTime.now());
      final afterCreation = DateTime.now();

      expect(
        goal.createdAt.isAfter(
          beforeCreation.subtract(const Duration(seconds: 1)),
        ),
        true,
      );
      expect(
        goal.createdAt.isBefore(afterCreation.add(const Duration(seconds: 1))),
        true,
      );
    });

    test('multiple copyWith calls maintain data integrity', () {
      final original = Goal(
        title: 'Original',
        description: 'Original description',
        targetDate: DateTime(2026, 6, 1),
        isAchieved: false,
      );

      final step1 = original.copyWith(title: 'Step 1');
      final step2 = step1.copyWith(description: 'Step 2 description');
      final step3 = step2.copyWith(isAchieved: true);

      expect(step3.title, 'Step 1');
      expect(step3.description, 'Step 2 description');
      expect(step3.isAchieved, true);
      expect(step3.targetDate, original.targetDate);
      expect(step3.id, original.id);
    });
  });
}
