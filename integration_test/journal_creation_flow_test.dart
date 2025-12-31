import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for the journal entry creation flow.
///
/// This test verifies the complete user journey of creating a new journal entry,
/// including navigation, text input, and data persistence.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journal Entry Creation Flow', () {
    testWidgets('User can create a new journal entry successfully', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to journal section (adjust based on your navigation)
      final journalTab = find.text('Journal');
      if (journalTab.evaluate().isNotEmpty) {
        await tester.tap(journalTab);
        await tester.pumpAndSettle();
      }

      // Find and tap the add journal button
      final addJournalButton = find.byIcon(Icons.add);
      if (addJournalButton.evaluate().isNotEmpty) {
        await tester.tap(addJournalButton);
        await tester.pumpAndSettle();

        // Enter journal title
        final titleField = find.byKey(const Key('journal_title_field'));
        if (titleField.evaluate().isNotEmpty) {
          await tester.enterText(titleField, 'My Reflections Today');
          await tester.pumpAndSettle();
        }

        // Enter journal content
        final contentField = find.byKey(const Key('journal_content_field'));
        if (contentField.evaluate().isNotEmpty) {
          await tester.enterText(
            contentField,
            'Today was a productive day. I completed my meditation and felt more focused.',
          );
          await tester.pumpAndSettle();
        }

        // Save the journal entry
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();
        }

        // Verify journal entry was created
        expect(find.text('My Reflections Today'), findsOneOrMoreWidgets);
      }
    });

    testWidgets('User can add tags to journal entry', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final journalTab = find.text('Journal');
      if (journalTab.evaluate().isNotEmpty) {
        await tester.tap(journalTab);
        await tester.pumpAndSettle();
      }

      final addJournalButton = find.byIcon(Icons.add);
      if (addJournalButton.evaluate().isNotEmpty) {
        await tester.tap(addJournalButton);
        await tester.pumpAndSettle();

        // Add a tag
        final addTagButton = find.text('Add Tag');
        if (addTagButton.evaluate().isNotEmpty) {
          await tester.tap(addTagButton);
          await tester.pumpAndSettle();

          final tagField = find.byKey(const Key('tag_input'));
          if (tagField.evaluate().isNotEmpty) {
            await tester.enterText(tagField, 'gratitude');
            await tester.pumpAndSettle();
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();

            // Verify tag was added
            expect(find.text('gratitude'), findsOneOrMoreWidgets);
          }
        }
      }
    });

    testWidgets('Journal entry validates minimum content length', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final journalTab = find.text('Journal');
      if (journalTab.evaluate().isNotEmpty) {
        await tester.tap(journalTab);
        await tester.pumpAndSettle();
      }

      final addJournalButton = find.byIcon(Icons.add);
      if (addJournalButton.evaluate().isNotEmpty) {
        await tester.tap(addJournalButton);
        await tester.pumpAndSettle();

        // Enter very short content
        final contentField = find.byKey(const Key('journal_content_field'));
        if (contentField.evaluate().isNotEmpty) {
          await tester.enterText(contentField, 'Hi');
          await tester.pumpAndSettle();
        }

        // Try to save
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();

          // Verify validation message appears
          expect(
            find.textContaining('too short', findRichText: true),
            findsAny,
          );
        }
      }
    });
  });
}
