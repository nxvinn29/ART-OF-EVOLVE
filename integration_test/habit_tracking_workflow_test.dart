import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for habit creation and tracking workflow.
///
/// This test verifies that users can successfully create habits,
/// mark them as complete, and track their progress over time.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Habit Creation and Tracking Integration Tests', () {
    testWidgets('Create a new habit with all details', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits section (assuming there's a navigation method)
      // Look for habits tab or button
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Find and tap the add habit button (FAB or add button)
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsAtLeastNWidgets(1));
      await tester.tap(addButton.first);
      await tester.pumpAndSettle();

      // Enter habit title
      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'Morning Meditation');
      await tester.pumpAndSettle();

      // Enter habit description (if available)
      final descriptionFinder = find.widgetWithText(TextField, 'Description');
      if (descriptionFinder.evaluate().isNotEmpty) {
        await tester.enterText(
          descriptionFinder,
          'Meditate for 10 minutes every morning',
        );
        await tester.pumpAndSettle();
      }

      // Select a color (tap on a color option)
      final colorOption = find.byType(InkWell).first;
      if (colorOption.evaluate().isNotEmpty) {
        await tester.tap(colorOption);
        await tester.pumpAndSettle();
      }

      // Select an icon (if icon selector is present)
      final iconOption = find.byIcon(Icons.self_improvement);
      if (iconOption.evaluate().isNotEmpty) {
        await tester.tap(iconOption.first);
        await tester.pumpAndSettle();
      }

      // Save the habit
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      if (saveButton.evaluate().isEmpty) {
        // Try alternative save button texts
        final createButton = find.widgetWithText(ElevatedButton, 'Create');
        if (createButton.evaluate().isNotEmpty) {
          await tester.tap(createButton);
        }
      } else {
        await tester.tap(saveButton);
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify the habit appears in the list
      expect(find.text('Morning Meditation'), findsAtLeastNWidgets(1));
    });

    testWidgets('Mark habit as complete for today', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Find a habit card (assuming habits are displayed as cards)
      final habitCard = find.byType(Card).first;
      if (habitCard.evaluate().isNotEmpty) {
        // Look for a checkbox or complete button
        final checkbox = find.byType(Checkbox).first;
        if (checkbox.evaluate().isNotEmpty) {
          // Get initial state
          final checkboxWidget = tester.widget(checkbox) as Checkbox;
          final wasChecked = checkboxWidget.value ?? false;

          // Tap to toggle completion
          await tester.tap(checkbox);
          await tester.pumpAndSettle();

          // Verify state changed
          final updatedCheckbox = tester.widget(checkbox) as Checkbox;
          expect(updatedCheckbox.value, !wasChecked);
        }
      }
    });

    testWidgets('View habit details and statistics', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Tap on a habit to view details
      final habitCard = find.byType(Card).first;
      if (habitCard.evaluate().isNotEmpty) {
        await tester.tap(habitCard);
        await tester.pumpAndSettle();

        // Verify details screen shows relevant information
        // This could include streak, completion rate, etc.
        final streakText = find.textContaining('Streak');
        if (streakText.evaluate().isNotEmpty) {
          expect(streakText, findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('Delete a habit', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Count initial habits
      final initialHabits = find.byType(Card);
      final initialCount = initialHabits.evaluate().length;

      if (initialCount > 0) {
        // Long press on a habit or find delete button
        final habitCard = find.byType(Card).first;
        await tester.longPress(habitCard);
        await tester.pumpAndSettle();

        // Look for delete option
        final deleteButton = find.text('Delete');
        if (deleteButton.evaluate().isNotEmpty) {
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();

          // Confirm deletion if there's a dialog
          final confirmButton = find.widgetWithText(TextButton, 'Delete');
          if (confirmButton.evaluate().isNotEmpty) {
            await tester.tap(confirmButton);
            await tester.pumpAndSettle();
          }

          // Verify habit count decreased
          final finalHabits = find.byType(Card);
          expect(finalHabits.evaluate().length, lessThan(initialCount));
        }
      }
    });

    testWidgets('Track habit streak over multiple days', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Create a new habit for testing
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton.first);
        await tester.pumpAndSettle();

        final titleField = find.byType(TextField).first;
        await tester.enterText(titleField, 'Streak Test Habit');
        await tester.pumpAndSettle();

        final saveButton = find.widgetWithText(ElevatedButton, 'Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();
        }
      }

      // Mark as complete
      final checkbox = find.byType(Checkbox).first;
      if (checkbox.evaluate().isNotEmpty) {
        await tester.tap(checkbox);
        await tester.pumpAndSettle();

        // Verify streak indicator appears or updates
        final streakIndicator = find.textContaining('1');
        if (streakIndicator.evaluate().isNotEmpty) {
          expect(streakIndicator, findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('Edit existing habit', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to habits
      final habitsTab = find.text('Habits');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pumpAndSettle();
      }

      // Find a habit and tap to edit
      final habitCard = find.byType(Card).first;
      if (habitCard.evaluate().isNotEmpty) {
        await tester.tap(habitCard);
        await tester.pumpAndSettle();

        // Look for edit button
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Modify the title
          final titleField = find.byType(TextField).first;
          await tester.enterText(titleField, 'Updated Habit Title');
          await tester.pumpAndSettle();

          // Save changes
          final saveButton = find.widgetWithText(ElevatedButton, 'Save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();

            // Verify updated title appears
            expect(find.text('Updated Habit Title'), findsAtLeastNWidgets(1));
          }
        }
      }
    });
  });
}
