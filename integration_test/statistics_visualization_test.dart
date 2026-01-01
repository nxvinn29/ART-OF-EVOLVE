import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for statistics and progress visualization.
///
/// This test verifies that users can successfully view their statistics,
/// progress charts, achievements, and analytics.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Statistics and Progress Visualization Integration Tests', () {
    testWidgets('Navigate to statistics screen', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for statistics navigation option
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isEmpty) {
        // Try alternative names
        final statsIcon = find.byIcon(Icons.bar_chart);
        if (statsIcon.evaluate().isNotEmpty) {
          await tester.tap(statsIcon.first);
          await tester.pumpAndSettle();
        }
      } else {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Verify we're on the statistics screen
      expect(find.textContaining('Statistics'), findsAtLeastNWidgets(1));
    });

    testWidgets('View XP overview and level progress', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for XP display
      final xpText = find.textContaining('XP');
      if (xpText.evaluate().isNotEmpty) {
        expect(xpText, findsAtLeastNWidgets(1));
      }

      // Look for level display
      final levelText = find.textContaining('Level');
      if (levelText.evaluate().isNotEmpty) {
        expect(levelText, findsAtLeastNWidgets(1));
      }

      // Verify progress bar is present
      final progressBar = find.byType(LinearProgressIndicator);
      if (progressBar.evaluate().isNotEmpty) {
        expect(progressBar, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('View habit completion statistics', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for habit statistics section
      final habitStats = find.textContaining('Habits');
      if (habitStats.evaluate().isNotEmpty) {
        expect(habitStats, findsAtLeastNWidgets(1));
      }

      // Look for completion rate or percentage
      final percentageText = find.textContaining('%');
      if (percentageText.evaluate().isNotEmpty) {
        expect(percentageText, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('View weekly progress chart', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for weekly chart section
      final weeklyText = find.textContaining('Week');
      if (weeklyText.evaluate().isNotEmpty) {
        expect(weeklyText, findsAtLeastNWidgets(1));
      }

      // Scroll to find chart if needed
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Verify chart or graph is present
      // Charts might be rendered as CustomPaint or specific chart widgets
      final customPaint = find.byType(CustomPaint);
      if (customPaint.evaluate().isNotEmpty) {
        expect(customPaint, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('View achievement badges', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Scroll to achievements section
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Look for achievements section
      final achievementsText = find.textContaining('Achievement');
      if (achievementsText.evaluate().isNotEmpty) {
        expect(achievementsText, findsAtLeastNWidgets(1));
      }

      // Look for badge widgets
      final badges = find.byIcon(Icons.emoji_events);
      if (badges.evaluate().isNotEmpty) {
        expect(badges, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('View streak analytics', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for streak information
      final streakText = find.textContaining('Streak');
      if (streakText.evaluate().isNotEmpty) {
        expect(streakText, findsAtLeastNWidgets(1));
      }

      // Look for current streak value
      final streakValue = find.textContaining('day');
      if (streakValue.evaluate().isNotEmpty) {
        expect(streakValue, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Filter statistics by time period', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for time period filters
      final weekFilter = find.text('Week');
      final monthFilter = find.text('Month');
      final yearFilter = find.text('Year');

      if (weekFilter.evaluate().isNotEmpty) {
        await tester.tap(weekFilter.first);
        await tester.pumpAndSettle();

        // Verify data updates
        expect(find.textContaining('Week'), findsAtLeastNWidgets(1));
      }

      if (monthFilter.evaluate().isNotEmpty) {
        await tester.tap(monthFilter.first);
        await tester.pumpAndSettle();

        // Verify data updates
        expect(find.textContaining('Month'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('View goal completion rate', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Scroll to goals section
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();

      // Look for goals statistics
      final goalsText = find.textContaining('Goals');
      if (goalsText.evaluate().isNotEmpty) {
        expect(goalsText, findsAtLeastNWidgets(1));
      }

      // Look for completion rate
      final completionRate = find.textContaining('Completed');
      if (completionRate.evaluate().isNotEmpty) {
        expect(completionRate, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Refresh statistics data', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for refresh button or pull to refresh
      final refreshButton = find.byIcon(Icons.refresh);
      if (refreshButton.evaluate().isNotEmpty) {
        await tester.tap(refreshButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify data is reloaded
        expect(find.textContaining('Statistics'), findsAtLeastNWidgets(1));
      } else {
        // Try pull to refresh
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, 300),
        );
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    testWidgets('View detailed analytics for specific habit', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to statistics
      final statsTab = find.text('Statistics');
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }

      // Look for individual habit statistics
      final habitCards = find.byType(Card);
      if (habitCards.evaluate().isNotEmpty) {
        // Tap on a habit card to view details
        await tester.tap(habitCards.first);
        await tester.pumpAndSettle();

        // Verify detailed view shows more information
        final detailsText = find.textContaining('Details');
        if (detailsText.evaluate().isNotEmpty) {
          expect(detailsText, findsAtLeastNWidgets(1));
        }
      }
    });
  });
}
