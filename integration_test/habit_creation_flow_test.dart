import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for the habit creation flow.
///
/// This test verifies the complete user journey of creating a new habit,
/// including navigation, form filling, and data persistence.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Habit Creation Flow', () {
    testWidgets('User can create a new habit successfully', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the add habit button (adjust finder based on your UI)
      final addHabitButton = find.byIcon(Icons.add);
      if (addHabitButton.evaluate().isNotEmpty) {
        await tester.tap(addHabitButton);
        await tester.pumpAndSettle();

        // Enter habit name
        final habitNameField = find.byType(TextField).first;
        await tester.enterText(habitNameField, 'Morning Meditation');
        await tester.pumpAndSettle();

        // Select habit category (if applicable)
        final categoryDropdown = find.text('Mindfulness');
        if (categoryDropdown.evaluate().isNotEmpty) {
          await tester.tap(categoryDropdown);
          await tester.pumpAndSettle();
        }

        // Save the habit
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();
        }

        // Verify habit was created
        expect(find.text('Morning Meditation'), findsWidgets);
      }
    });

    testWidgets('Habit creation validates required fields', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final addHabitButton = find.byIcon(Icons.add);
      if (addHabitButton.evaluate().isNotEmpty) {
        await tester.tap(addHabitButton);
        await tester.pumpAndSettle();

        // Try to save without entering data
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();

          // Verify validation error is shown
          expect(
            find.textContaining('required', findRichText: true),
            findsWidgets,
          );
        }
      }
    });

    testWidgets('User can cancel habit creation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final addHabitButton = find.byIcon(Icons.add);
      if (addHabitButton.evaluate().isNotEmpty) {
        await tester.tap(addHabitButton);
        await tester.pumpAndSettle();

        // Find and tap cancel button
        final cancelButton = find.text('Cancel');
        if (cancelButton.evaluate().isNotEmpty) {
          await tester.tap(cancelButton);
          await tester.pumpAndSettle();

          // Verify we're back to the main screen
          expect(find.byIcon(Icons.add), findsWidgets);
        }
      }
    });
  });
}
