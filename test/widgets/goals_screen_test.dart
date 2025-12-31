import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_screen.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_controller.dart';

void main() {
  group('GoalsScreen Widget Tests', () {
    testWidgets('displays loading indicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(const AsyncLoading());
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no goals', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(const AsyncData([]));
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No goals yet'), findsAny);
    });

    testWidgets('displays list of goals', (WidgetTester tester) async {
      final goals = [
        Goal(
          title: 'Learn Flutter',
          description: 'Master Flutter development',
          targetDate: DateTime(2025, 12, 31),
        ),
        Goal(
          title: 'Exercise Daily',
          description: '30 minutes of exercise',
          targetDate: DateTime(2025, 6, 30),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(AsyncData(goals));
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Learn Flutter'), findsOneWidget);
      expect(find.text('Exercise Daily'), findsOneWidget);
    });

    testWidgets('displays error message on error', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(
                AsyncError(Exception('Failed to load'), StackTrace.empty),
              );
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsAny);
    });

    testWidgets('add goal button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(const AsyncData([]));
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('goal cards are tappable', (WidgetTester tester) async {
      final goals = [
        Goal(
          title: 'Test Goal',
          description: 'Test description',
          targetDate: DateTime(2025, 12, 31),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) {
              return TestGoalsController(AsyncData(goals));
            }),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final goalCard = find.text('Test Goal');
      expect(goalCard, findsOneWidget);

      await tester.tap(goalCard);
      await tester.pumpAndSettle();
    });
  });
}

/// Test implementation of GoalsController for widget testing
class TestGoalsController extends StateNotifier<AsyncValue<List<Goal>>> {
  TestGoalsController(AsyncValue<List<Goal>> initialState)
    : super(initialState);

  @override
  Future<void> loadGoals() async {}

  @override
  Future<void> addGoal(
    String title,
    DateTime targetDate, {
    String description = '',
  }) async {}

  @override
  Future<void> toggleGoal(String id) async {}

  @override
  Future<void> deleteGoal(String id) async {}
}
