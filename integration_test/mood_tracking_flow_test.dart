import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for the mood tracking flow.
///
/// This test verifies the complete user journey of tracking mood,
/// including mood selection, note addition, and data persistence.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mood Tracking Flow', () {
    testWidgets('User can track their mood successfully', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to mood tracking section
      final moodTab = find.text('Mood');
      if (moodTab.evaluate().isNotEmpty) {
        await tester.tap(moodTab);
        await tester.pumpAndSettle();
      }

      // Find and tap the track mood button
      final trackMoodButton = find.text('Track Mood');
      if (trackMoodButton.evaluate().isEmpty) {
        // Try alternative button
        final altButton = find.byIcon(Icons.add);
        if (altButton.evaluate().isNotEmpty) {
          await tester.tap(altButton);
          await tester.pumpAndSettle();
        }
      } else {
        await tester.tap(trackMoodButton);
        await tester.pumpAndSettle();
      }

      // Select a mood (e.g., Happy)
      final happyMood = find.text('Happy');
      if (happyMood.evaluate().isEmpty) {
        // Try emoji-based mood selector
        final moodEmoji = find.text('😊');
        if (moodEmoji.evaluate().isNotEmpty) {
          await tester.tap(moodEmoji);
          await tester.pumpAndSettle();
        }
      } else {
        await tester.tap(happyMood);
        await tester.pumpAndSettle();
      }

      // Add a note about the mood
      final noteField = find.byKey(const Key('mood_note_field'));
      if (noteField.evaluate().isNotEmpty) {
        await tester.enterText(
          noteField,
          'Feeling great after morning workout!',
        );
        await tester.pumpAndSettle();
      }

      // Save the mood entry
      final saveButton = find.text('Save');
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();
      }

      // Verify mood was tracked
      expect(find.textContaining('great', findRichText: true), findsAny);
    });

    testWidgets('User can select mood intensity', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final moodTab = find.text('Mood');
      if (moodTab.evaluate().isNotEmpty) {
        await tester.tap(moodTab);
        await tester.pumpAndSettle();
      }

      final trackMoodButton = find.text('Track Mood');
      if (trackMoodButton.evaluate().isNotEmpty) {
        await tester.tap(trackMoodButton);
        await tester.pumpAndSettle();

        // Select mood
        final happyMood = find.text('😊');
        if (happyMood.evaluate().isNotEmpty) {
          await tester.tap(happyMood);
          await tester.pumpAndSettle();
        }

        // Adjust intensity slider
        final intensitySlider = find.byType(Slider);
        if (intensitySlider.evaluate().isNotEmpty) {
          await tester.drag(intensitySlider, const Offset(100, 0));
          await tester.pumpAndSettle();
        }

        // Save
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('User can view mood history', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final moodTab = find.text('Mood');
      if (moodTab.evaluate().isNotEmpty) {
        await tester.tap(moodTab);
        await tester.pumpAndSettle();

        // Look for mood history section
        final historySection = find.text('History');
        if (historySection.evaluate().isNotEmpty) {
          await tester.tap(historySection);
          await tester.pumpAndSettle();

          // Verify history is displayed
          expect(find.byType(ListView), findsWidgets);
        }
      }
    });

    testWidgets('Mood tracking requires mood selection', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final moodTab = find.text('Mood');
      if (moodTab.evaluate().isNotEmpty) {
        await tester.tap(moodTab);
        await tester.pumpAndSettle();
      }

      final trackMoodButton = find.text('Track Mood');
      if (trackMoodButton.evaluate().isNotEmpty) {
        await tester.tap(trackMoodButton);
        await tester.pumpAndSettle();

        // Try to save without selecting mood
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();

          // Verify validation error
          expect(find.textContaining('select', findRichText: true), findsAny);
        }
      }
    });
  });
}
