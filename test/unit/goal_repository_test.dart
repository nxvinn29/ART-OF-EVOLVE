import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/features/goals/data/goal_repository.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';

void main() {
  group('GoalRepository Tests', () {
    late Box<Goal> box;
    late GoalRepository repository;

    setUp(() async {
      await setUpTestHive();
      // Register adapter if not already registered (mock or real)
      // Since we are using a real box with generic T, we might need to register the adapter.
      // However, for test boxes often we can skip or register a mock adapter.
      // But Goal relies on HiveType(typeId: 2).
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(GoalAdapter());
      }
      box = await Hive.openBox<Goal>('goals');
      repository = GoalRepository(box);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('getGoals returns empty list initially', () async {
      final goals = await repository.getGoals();
      expect(goals, isEmpty);
    });

    test('saveGoal adds a goal to the box', () async {
      final goal = Goal(title: 'Test Goal', targetDate: DateTime(2025, 12, 31));

      await repository.saveGoal(goal);

      final goals = await repository.getGoals();
      expect(goals.length, 1);
      expect(goals.first.title, 'Test Goal');
      expect(goals.first.id, goal.id);
    });

    test('saveGoal updates existing goal', () async {
      final goal = Goal(
        title: 'Initial Title',
        targetDate: DateTime(2025, 12, 31),
      );
      await repository.saveGoal(goal);

      final updatedGoal = goal.copyWith(title: 'Updated Title');
      await repository.saveGoal(updatedGoal);

      final goals = await repository.getGoals();
      expect(goals.length, 1);
      expect(goals.first.title, 'Updated Title');
    });

    test('deleteGoal removes goal', () async {
      final goal = Goal(title: 'To Delete', targetDate: DateTime(2025, 12, 31));
      await repository.saveGoal(goal);

      await repository.deleteGoal(goal.id);

      final goals = await repository.getGoals();
      expect(goals, isEmpty);
    });

    test('deleteGoal does nothing if id not found', () async {
      await repository.deleteGoal('non-existent-id');
      // Should not throw
    });
  });
}
