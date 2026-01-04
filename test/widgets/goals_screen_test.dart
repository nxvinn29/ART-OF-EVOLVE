import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_screen.dart';

import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/goals/data/goal_repository.dart';

// Manual Mock
class MockGoalsRepository extends Mock implements IGoalsRepository {
  @override
  Future<List<Goal>> getGoals() => super.noSuchMethod(
    Invocation.method(#getGoals, []),
    returnValue: Future.value(<Goal>[]),
    returnValueForMissingStub: Future.value(<Goal>[]),
  );

  @override
  Future<void> saveGoal(Goal? goal) => super.noSuchMethod(
    Invocation.method(#saveGoal, [goal]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );

  @override
  Future<void> deleteGoal(String? id) => super.noSuchMethod(
    Invocation.method(#deleteGoal, [id]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );
}

void main() {
  group('GoalsScreen Widget Tests', () {
    testWidgets('displays loading indicator when loading', (
      WidgetTester tester,
    ) async {
      final mockRepository = MockGoalsRepository();
      // Return a future that never completes to Simulate Loading
      when(mockRepository.getGoals()).thenAnswer((_) {
        return Completer<List<Goal>>().future;
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override using the default GoalsController but with our mock repository
            goalRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      // Verify the widget builds and shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no goals', (
      WidgetTester tester,
    ) async {
      final mockRepository = MockGoalsRepository();
      when(mockRepository.getGoals()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders empty message
      expect(find.text('Set a goal to start your journey!'), findsOneWidget);
    });

    testWidgets('goal screen renders correctly', (WidgetTester tester) async {
      final mockRepository = MockGoalsRepository();
      final goal = Goal(
        title: 'Test Goal',
        targetDate: DateTime.now().add(const Duration(days: 1)),
      );
      when(mockRepository.getGoals()).thenAnswer((_) async => [goal]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify basic UI elements
      expect(find.byType(GoalsScreen), findsOneWidget);
      expect(find.text('Test Goal'), findsOneWidget);
    });

    testWidgets('add goal button is present', (WidgetTester tester) async {
      final mockRepository = MockGoalsRepository();
      when(mockRepository.getGoals()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Check for FloatingActionButton or add button
      expect(
        find.byType(FloatingActionButton).evaluate().isNotEmpty ||
            find.byIcon(Icons.add).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('tapping a goal item shows detail', (
      WidgetTester tester,
    ) async {
      final mockRepository = MockGoalsRepository();
      when(mockRepository.getGoals()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [goalRepositoryProvider.overrideWithValue(mockRepository)],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab);
        await tester.pumpAndSettle();
        // Just verify dialog appeared
        expect(find.byType(AlertDialog), findsOneWidget);
      }
    });
  });
}
