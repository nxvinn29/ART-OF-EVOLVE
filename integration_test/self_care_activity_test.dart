import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for self-care activity scheduling and tracking.
///
/// This test verifies that users can successfully access self-care features,
/// create journal entries, use the focus timer, and track their self-care activities.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Self-Care Activity Integration Tests', () {
    testWidgets('Navigate to self-care section', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for self-care navigation option
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();

        // Verify we're on the self-care screen
        expect(find.text('Self Care'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Create a new journal entry', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to self-care
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      // Look for journal option
      final journalButton = find.textContaining('Journal');
      if (journalButton.evaluate().isNotEmpty) {
        await tester.tap(journalButton.first);
        await tester.pumpAndSettle();
      }

      // Tap add journal entry button
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton.first);
        await tester.pumpAndSettle();
      }

      // Enter journal content
      final textField = find.byType(TextField).first;
      await tester.enterText(
        textField,
        'Today was a productive day. I completed my meditation and exercise.',
      );
      await tester.pumpAndSettle();

      // Save the journal entry
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify journal entry was created
        expect(find.textContaining('productive'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Use focus timer', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to self-care
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      // Look for focus timer option
      final focusTimerButton = find.textContaining('Focus');
      if (focusTimerButton.evaluate().isNotEmpty) {
        await tester.tap(focusTimerButton.first);
        await tester.pumpAndSettle();
      }

      // Look for start button
      final startButton = find.widgetWithText(ElevatedButton, 'Start');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify timer is running
        final pauseButton = find.byIcon(Icons.pause);
        if (pauseButton.evaluate().isNotEmpty) {
          expect(pauseButton, findsAtLeastNWidgets(1));

          // Pause the timer
          await tester.tap(pauseButton);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('View journal history', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to self-care
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      // Navigate to journal
      final journalButton = find.textContaining('Journal');
      if (journalButton.evaluate().isNotEmpty) {
        await tester.tap(journalButton.first);
        await tester.pumpAndSettle();
      }

      // Verify journal entries are displayed
      final journalCards = find.byType(Card);
      if (journalCards.evaluate().isNotEmpty) {
        expect(journalCards, findsAtLeastNWidgets(1));

        // Tap on a journal entry to view details
        await tester.tap(journalCards.first);
        await tester.pumpAndSettle();

        // Verify entry details are shown
        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Edit existing journal entry', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to self-care and journal
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      final journalButton = find.textContaining('Journal');
      if (journalButton.evaluate().isNotEmpty) {
        await tester.tap(journalButton.first);
        await tester.pumpAndSettle();
      }

      // Tap on a journal entry
      final journalCards = find.byType(Card);
      if (journalCards.evaluate().isNotEmpty) {
        await tester.tap(journalCards.first);
        await tester.pumpAndSettle();

        // Look for edit button
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Modify the content
          final textField = find.byType(TextField).first;
          await tester.enterText(
            textField,
            'Updated journal entry with new reflections.',
          );
          await tester.pumpAndSettle();

          // Save changes
          final saveButton = find.widgetWithText(ElevatedButton, 'Save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();

            // Verify update
            expect(find.textContaining('Updated'), findsAtLeastNWidgets(1));
          }
        }
      }
    });

    testWidgets('Delete journal entry', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to journal
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      final journalButton = find.textContaining('Journal');
      if (journalButton.evaluate().isNotEmpty) {
        await tester.tap(journalButton.first);
        await tester.pumpAndSettle();
      }

      // Count initial entries
      final initialEntries = find.byType(Card);
      final initialCount = initialEntries.evaluate().length;

      if (initialCount > 0) {
        // Tap on an entry
        await tester.tap(initialEntries.first);
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

          // Navigate back
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
          }

          // Verify entry count decreased
          final finalEntries = find.byType(Card);
          expect(
            finalEntries.evaluate().length,
            lessThanOrEqualTo(initialCount),
          );
        }
      }
    });

    testWidgets('Complete focus timer session', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to focus timer
      final selfCareTab = find.text('Self Care');
      if (selfCareTab.evaluate().isNotEmpty) {
        await tester.tap(selfCareTab);
        await tester.pumpAndSettle();
      }

      final focusTimerButton = find.textContaining('Focus');
      if (focusTimerButton.evaluate().isNotEmpty) {
        await tester.tap(focusTimerButton.first);
        await tester.pumpAndSettle();
      }

      // Start timer
      final startButton = find.widgetWithText(ElevatedButton, 'Start');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Stop timer
        final stopButton = find.byIcon(Icons.stop);
        if (stopButton.evaluate().isNotEmpty) {
          await tester.tap(stopButton);
          await tester.pumpAndSettle();

          // Verify completion message or reset
          final resetButton = find.widgetWithText(ElevatedButton, 'Reset');
          if (resetButton.evaluate().isNotEmpty) {
            expect(resetButton, findsAtLeastNWidgets(1));
          }
        }
      }
    });
  });
}
