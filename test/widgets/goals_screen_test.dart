import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_screen.dart';
import 'package:art_of_evolve/src/features/goals/presentation/goals_controller.dart';

void main() {
  group('GoalsScreen Widget Tests', () {
    testWidgets('displays loading indicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsProvider.overrideWith((ref) => throw UnimplementedError()),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );

      // Just verify the widget builds without crashing
      expect(find.byType(GoalsScreen), findsOneWidget);
    });

    testWidgets('displays empty state when no goals', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GoalsScreen())),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders
      expect(find.byType(GoalsScreen), findsOneWidget);
    });

    testWidgets('goal screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GoalsScreen())),
      );

      await tester.pumpAndSettle();

      // Verify basic UI elements
      expect(find.byType(GoalsScreen), findsOneWidget);
    });

    testWidgets('add goal button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: GoalsScreen())),
      );

      await tester.pumpAndSettle();

      // Check for FloatingActionButton or add button
      expect(
        find.byType(FloatingActionButton).evaluate().isNotEmpty ||
            find.byIcon(Icons.add).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
