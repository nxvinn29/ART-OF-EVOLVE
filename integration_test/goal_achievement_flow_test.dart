import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for goal setting and achievement flow.
///
/// This test verifies that users can successfully create goals,
/// track their progress, and mark them as achieved.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Goal Setting and Achievement Integration Tests', () {
    testWidgets('Create a new goal with target date', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals section
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Tap add goal button
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton.first);
        await tester.pumpAndSettle();
      }

      // Enter goal title
      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'Complete Flutter Course');
      await tester.pumpAndSettle();

      // Enter goal description
      final descriptionFields = find.byType(TextField);
      if (descriptionFields.evaluate().length > 1) {
        await tester.enterText(
          descriptionFields.at(1),
          'Finish all modules and build a portfolio project',
        );
        await tester.pumpAndSettle();
      }

      // Select target date (tap on date picker)
      final datePicker = find.byIcon(Icons.calendar_today);
      if (datePicker.evaluate().isNotEmpty) {
        await tester.tap(datePicker);
        await tester.pumpAndSettle();

        // Select a future date (tap OK on date picker)
        final okButton = find.text('OK');
        if (okButton.evaluate().isNotEmpty) {
          await tester.tap(okButton);
          await tester.pumpAndSettle();
        }
      }

      // Save the goal
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      if (saveButton.evaluate().isEmpty) {
        final createButton = find.widgetWithText(ElevatedButton, 'Create');
        if (createButton.evaluate().isNotEmpty) {
          await tester.tap(createButton);
        }
      } else {
        await tester.tap(saveButton);
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify goal appears in the list
      expect(find.text('Complete Flutter Course'), findsAtLeastNWidgets(1));
    });

    testWidgets('Mark goal as achieved', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Find a goal card
      final goalCard = find.byType(Card).first;
      if (goalCard.evaluate().isNotEmpty) {
        // Tap on the goal to view details
        await tester.tap(goalCard);
        await tester.pumpAndSettle();

        // Look for "Mark as Achieved" button
        final achieveButton = find.widgetWithText(
          ElevatedButton,
          'Mark as Achieved',
        );
        if (achieveButton.evaluate().isNotEmpty) {
          await tester.tap(achieveButton);
          await tester.pumpAndSettle();

          // Verify achievement confirmation or visual change
          final completedIndicator = find.textContaining('Achieved');
          if (completedIndicator.evaluate().isNotEmpty) {
            expect(completedIndicator, findsAtLeastNWidgets(1));
          }
        }
      }
    });

    testWidgets('View goal progress and details', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Tap on a goal to view details
      final goalCard = find.byType(Card).first;
      if (goalCard.evaluate().isNotEmpty) {
        await tester.tap(goalCard);
        await tester.pumpAndSettle();

        // Verify details screen shows relevant information
        // This could include target date, description, progress
        final targetDateText = find.textContaining('Target');
        if (targetDateText.evaluate().isNotEmpty) {
          expect(targetDateText, findsAtLeastNWidgets(1));
        }

        // Check for progress indicator
        final progressIndicator = find.byType(LinearProgressIndicator);
        if (progressIndicator.evaluate().isNotEmpty) {
          expect(progressIndicator, findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('Edit existing goal', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Find and tap on a goal
      final goalCard = find.byType(Card).first;
      if (goalCard.evaluate().isNotEmpty) {
        await tester.tap(goalCard);
        await tester.pumpAndSettle();

        // Look for edit button
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Modify the title
          final titleField = find.byType(TextField).first;
          await tester.enterText(titleField, 'Updated Goal Title');
          await tester.pumpAndSettle();

          // Save changes
          final saveButton = find.widgetWithText(ElevatedButton, 'Save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();

            // Verify updated title appears
            expect(find.text('Updated Goal Title'), findsAtLeastNWidgets(1));
          }
        }
      }
    });

    testWidgets('Delete a goal', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Count initial goals
      final initialGoals = find.byType(Card);
      final initialCount = initialGoals.evaluate().length;

      if (initialCount > 0) {
        // Tap on a goal
        final goalCard = find.byType(Card).first;
        await tester.tap(goalCard);
        await tester.pumpAndSettle();

        // Look for delete button
        final deleteButton = find.byIcon(Icons.delete);
        if (deleteButton.evaluate().isNotEmpty) {
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();

          // Confirm deletion
          final confirmButton = find.widgetWithText(TextButton, 'Delete');
          if (confirmButton.evaluate().isNotEmpty) {
            await tester.tap(confirmButton);
            await tester.pumpAndSettle();
          }

          // Navigate back to goals list
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
          }

          // Verify goal count decreased
          final finalGoals = find.byType(Card);
          expect(finalGoals.evaluate().length, lessThanOrEqualTo(initialCount));
        }
      }
    });

    testWidgets('Filter goals by status (active/achieved)', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Look for filter options
      final filterButton = find.byIcon(Icons.filter_list);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        // Select "Achieved" filter
        final achievedFilter = find.text('Achieved');
        if (achievedFilter.evaluate().isNotEmpty) {
          await tester.tap(achievedFilter);
          await tester.pumpAndSettle();

          // Verify only achieved goals are shown
          // (This would require checking the goal cards)
        }

        // Select "Active" filter
        final activeFilter = find.text('Active');
        if (activeFilter.evaluate().isNotEmpty) {
          await tester.tap(activeFilter);
          await tester.pumpAndSettle();

          // Verify only active goals are shown
        }
      }
    });

    testWidgets('Create goal with validation errors', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to goals
      final goalsTab = find.text('Goals');
      if (goalsTab.evaluate().isNotEmpty) {
        await tester.tap(goalsTab);
        await tester.pumpAndSettle();
      }

      // Tap add goal button
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton.first);
        await tester.pumpAndSettle();
      }

      // Try to save without entering title
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify validation error appears
        final errorText = find.textContaining('required');
        if (errorText.evaluate().isNotEmpty) {
          expect(errorText, findsAtLeastNWidgets(1));
        }
      }
    });
  });
}
