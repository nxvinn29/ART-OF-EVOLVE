import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_screen.dart';

import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/goals/data/goal_repository.dart';
import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';

// Reuse mock from goals_controller_test or simple implementation
class MockGoalsRepository implements IGoalsRepository {
  final List<Goal> _goals = [];

  @override
  Future<List<Goal>> getGoals() async {
    return List.from(_goals);
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
    } else {
      _goals.add(goal);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
  }
}

void main() {
  testWidgets('GoalsScreen shows empty state initially', (tester) async {
    final mockRepository = MockGoalsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
        child: const MaterialApp(home: GoalsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Set a goal to start your journey!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('GoalsScreen shows list of goals', (tester) async {
    final mockRepository = MockGoalsRepository();
    final goal = Goal(
      title: 'Test Goal',
      targetDate: DateTime.now().add(const Duration(days: 5)),
    );
    mockRepository.addGoal(goal);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
        child: const MaterialApp(home: GoalsScreen()),
      ),
    );

    // Initial load
    await tester.pumpAndSettle();

    expect(find.text('Test Goal'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('FAB opens add goal dialog', (tester) async {
    final mockRepository = MockGoalsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
        child: const MaterialApp(home: GoalsScreen()),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('New Goal'), findsNWidgets(2)); // Title and Dialog Title
    expect(find.byType(TextField), findsOneWidget);
  });
}
