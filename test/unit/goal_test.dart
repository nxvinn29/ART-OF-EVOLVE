import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';

void main() {
  group('Goal Model Tests', () {
    test('should create a valid Goal instance', () {
      final goal = Goal(
        title: 'Learn Flutter',
        targetDate: DateTime(2025, 12, 31),
      );

      expect(goal.title, 'Learn Flutter');
      expect(goal.isAchieved, false);
      expect(goal.id, isNotNull);
      expect(goal.description, isEmpty);
    });

    test('should update fields using copyWith', () {
      final goal = Goal(title: 'Old Title', targetDate: DateTime.now());

      final updatedGoal = goal.copyWith(title: 'New Title', isAchieved: true);

      expect(updatedGoal.title, 'New Title');
      expect(updatedGoal.isAchieved, true);
      expect(updatedGoal.id, goal.id); // ID should remain same
    });

    test('should keep old values if copyWith is called with nulls', () {
      final goal = Goal(title: 'Keep Me', targetDate: DateTime(2024));

      final sameGoal = goal.copyWith();

      expect(sameGoal.title, goal.title);
      expect(sameGoal.targetDate, goal.targetDate);
    });
  });
}
