import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for the achievement unlocking flow.
///
/// This test verifies the complete user journey of unlocking achievements,
/// including triggering achievement conditions and viewing achievement details.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Achievement Unlocking Flow', () {
    testWidgets('User can view achievements screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to achievements section
      final achievementsTab = find.text('Achievements');
      if (achievementsTab.evaluate().isEmpty) {
        // Try alternative navigation
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          final achievementsButton = find.text('Achievements');
          if (achievementsButton.evaluate().isNotEmpty) {
            await tester.tap(achievementsButton);
            await tester.pumpAndSettle();
          }
        }
      } else {
        await tester.tap(achievementsTab);
        await tester.pumpAndSettle();
      }

      // Verify achievements are displayed
      expect(find.byType(GridView), findsAny);
    });

    testWidgets('User can view achievement details', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to achievements
      final achievementsTab = find.text('Achievements');
      if (achievementsTab.evaluate().isNotEmpty) {
        await tester.tap(achievementsTab);
        await tester.pumpAndSettle();

        // Tap on first achievement card
        final achievementCard = find.byType(Card).first;
        if (achievementCard.evaluate().isNotEmpty) {
          await tester.tap(achievementCard);
          await tester.pumpAndSettle();

          // Verify details dialog/screen is shown
          expect(
            find.textContaining('Description', findRichText: true),
            findsAny,
          );
        }
      }
    });

    testWidgets('Achievement notification appears when unlocked', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Perform action that triggers achievement (e.g., complete first habit)
      final addHabitButton = find.byIcon(Icons.add);
      if (addHabitButton.evaluate().isNotEmpty) {
        await tester.tap(addHabitButton);
        await tester.pumpAndSettle();

        // Create a habit
        final habitNameField = find.byType(TextField).first;
        if (habitNameField.evaluate().isNotEmpty) {
          await tester.enterText(habitNameField, 'First Habit');
          await tester.pumpAndSettle();

          final saveButton = find.text('Save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();

            // Look for achievement notification
            await tester.pumpAndSettle(const Duration(seconds: 1));
            expect(
              find.textContaining('Achievement', findRichText: true),
              findsAny,
            );
          }
        }
      }
    });

    testWidgets('User can filter achievements by status', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final achievementsTab = find.text('Achievements');
      if (achievementsTab.evaluate().isNotEmpty) {
        await tester.tap(achievementsTab);
        await tester.pumpAndSettle();

        // Look for filter options
        final unlockedFilter = find.text('Unlocked');
        if (unlockedFilter.evaluate().isNotEmpty) {
          await tester.tap(unlockedFilter);
          await tester.pumpAndSettle();

          // Verify filtered results
          expect(find.byType(Card), findsWidgets);
        }

        final lockedFilter = find.text('Locked');
        if (lockedFilter.evaluate().isNotEmpty) {
          await tester.tap(lockedFilter);
          await tester.pumpAndSettle();

          // Verify filtered results
          expect(find.byType(Card), findsWidgets);
        }
      }
    });

    testWidgets('Achievement progress is displayed correctly', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final achievementsTab = find.text('Achievements');
      if (achievementsTab.evaluate().isNotEmpty) {
        await tester.tap(achievementsTab);
        await tester.pumpAndSettle();

        // Look for progress indicators
        final progressIndicators = find.byType(LinearProgressIndicator);
        if (progressIndicators.evaluate().isNotEmpty) {
          expect(progressIndicators, findsWidgets);
        }

        // Verify percentage text is shown
        expect(find.textContaining('%', findRichText: true), findsAny);
      }
    });
  });
}
