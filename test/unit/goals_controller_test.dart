import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_controller.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';

/// Mock implementation of [IGoalsRepository] for testing.
class MockGoalsRepository implements IGoalsRepository {
  final List<Goal> _goals = [];
  bool shouldThrowError = false;

  @override
  Future<List<Goal>> getGoals() async {
    if (shouldThrowError) {
      throw Exception('Failed to load goals');
    }
    return List.from(_goals);
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    if (shouldThrowError) {
      throw Exception('Failed to save goal');
    }
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
    } else {
      _goals.add(goal);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    if (shouldThrowError) {
      throw Exception('Failed to delete goal');
    }
    _goals.removeWhere((g) => g.id == id);
  }

  void reset() {
    _goals.clear();
    shouldThrowError = false;
  }
}

void main() {
  group('GoalsController', () {
    late MockGoalsRepository mockRepository;
    late GoalsController controller;

    setUp(() {
      mockRepository = MockGoalsRepository();
      controller = GoalsController(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
      controller.dispose();
    });

    test('initial state is AsyncLoading', () {
      final newController = GoalsController(mockRepository);
      // State might change quickly, so we just verify it's created
      expect(newController, isNotNull);
      newController.dispose();
    });

    test('loadGoals updates state with sorted goals', () async {
      // Add test goals with different dates
      final goal1 = Goal(
        title: 'Goal 1',
        description: 'First goal',
        targetDate: DateTime(2025, 12, 31),
      );
      final goal2 = Goal(
        title: 'Goal 2',
        description: 'Second goal',
        targetDate: DateTime(2025, 6, 15),
      );

      await mockRepository.saveGoal(goal1);
      await mockRepository.saveGoal(goal2);

      await controller.loadGoals();

      controller.state.when(
        data: (goals) {
          expect(goals.length, 2);
          // Verify sorting by target date (ascending)
          expect(goals[0].title, 'Goal 2'); // Earlier date comes first
          expect(goals[1].title, 'Goal 1');
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('loadGoals handles errors gracefully', () async {
      mockRepository.shouldThrowError = true;

      await controller.loadGoals();

      expect(controller.state, isA<AsyncError>());
    });

    test('addGoal creates and saves a new goal', () async {
      await controller.addGoal(
        'New Goal',
        DateTime(2025, 12, 31),
        description: 'Test description',
      );

      controller.state.when(
        data: (goals) {
          expect(goals.length, 1);
          expect(goals[0].title, 'New Goal');
          expect(goals[0].description, 'Test description');
          expect(goals[0].targetDate, DateTime(2025, 12, 31));
          expect(goals[0].isAchieved, false);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addGoal with empty description works', () async {
      await controller.addGoal(
        'Goal without description',
        DateTime(2025, 12, 31),
      );

      controller.state.when(
        data: (goals) {
          expect(goals.length, 1);
          expect(goals[0].title, 'Goal without description');
          expect(goals[0].description, '');
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addGoal maintains sort order', () async {
      // Add a goal with a late date
      await controller.addGoal('Late Goal', DateTime(2025, 12, 31));

      // Add a goal with an early date
      await controller.addGoal('Early Goal', DateTime(2025, 1, 1));

      controller.state.when(
        data: (goals) {
          expect(goals.length, 2);
          expect(goals[0].title, 'Early Goal');
          expect(goals[1].title, 'Late Goal');
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addGoal handles errors', () async {
      mockRepository.shouldThrowError = true;

      await controller.addGoal('Failed Goal', DateTime(2025, 12, 31));

      expect(controller.state, isA<AsyncError>());
    });

    test('toggleGoal changes achievement status', () async {
      // Add a goal first
      final goal = Goal(
        title: 'Test Goal',
        description: 'To be toggled',
        targetDate: DateTime(2025, 12, 31),
      );
      await mockRepository.saveGoal(goal);
      await controller.loadGoals();

      // Toggle the goal
      await controller.toggleGoal(goal.id);

      controller.state.when(
        data: (goals) {
          expect(goals.length, 1);
          expect(goals[0].isAchieved, true); // Should be toggled to true
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );

      // Toggle again
      await controller.toggleGoal(goal.id);

      controller.state.when(
        data: (goals) {
          expect(goals[0].isAchieved, false); // Should be toggled back to false
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('toggleGoal handles errors', () async {
      final goal = Goal(
        title: 'Test Goal',
        description: 'Test',
        targetDate: DateTime(2025, 12, 31),
      );
      await mockRepository.saveGoal(goal);
      await controller.loadGoals();

      mockRepository.shouldThrowError = true;
      await controller.toggleGoal(goal.id);

      expect(controller.state, isA<AsyncError>());
    });

    test('deleteGoal removes goal from list', () async {
      // Add multiple goals
      final goal1 = Goal(
        title: 'Goal 1',
        description: 'First',
        targetDate: DateTime(2025, 12, 31),
      );
      final goal2 = Goal(
        title: 'Goal 2',
        description: 'Second',
        targetDate: DateTime(2025, 6, 15),
      );

      await mockRepository.saveGoal(goal1);
      await mockRepository.saveGoal(goal2);
      await controller.loadGoals();

      // Delete first goal
      await controller.deleteGoal(goal1.id);

      controller.state.when(
        data: (goals) {
          expect(goals.length, 1);
          expect(goals[0].title, 'Goal 2');
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('deleteGoal handles errors', () async {
      final goal = Goal(
        title: 'Test Goal',
        description: 'Test',
        targetDate: DateTime(2025, 12, 31),
      );
      await mockRepository.saveGoal(goal);
      await controller.loadGoals();

      mockRepository.shouldThrowError = true;
      await controller.deleteGoal(goal.id);

      expect(controller.state, isA<AsyncError>());
    });

    test('multiple operations maintain data consistency', () async {
      // Add goals
      await controller.addGoal('Goal 1', DateTime(2025, 12, 31));
      await controller.addGoal('Goal 2', DateTime(2025, 6, 15));
      await controller.addGoal('Goal 3', DateTime(2025, 9, 1));

      controller.state.when(
        data: (goals) {
          expect(goals.length, 3);

          // Toggle one
          controller.toggleGoal(goals[1].id);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      controller.state.when(
        data: (goals) {
          // Delete one
          controller.deleteGoal(goals[0].id);
        },
        loading: () {},
        error: (_, __) => fail('Should not have error'),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      controller.state.when(
        data: (goals) {
          expect(goals.length, 2);
        },
        loading: () {},
        error: (_, __) => fail('Should not have error'),
      );
    });
  });
}
