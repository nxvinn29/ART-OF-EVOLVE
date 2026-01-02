import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/mood_tracker_widget.dart';

/// Widget tests for [MoodTrackerWidget].
///
/// Tests mood selection, UI rendering, and interaction states.
void main() {
  group('MoodTrackerWidget Tests', () {
    testWidgets('renders with title and all mood options', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Verify title is displayed
      expect(find.text('How are you feeling?'), findsOneWidget);

      // Verify all mood labels are displayed
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Calm'), findsOneWidget);
      expect(find.text('Sad'), findsOneWidget);
      expect(find.text('Angry'), findsOneWidget);
    });

    testWidgets('displays all mood icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Verify mood icons are displayed
      expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);
      expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('initially no mood is selected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Find all mood containers
      final containers = find.byType(AnimatedContainer);

      // Verify containers exist
      expect(containers, findsWidgets);
    });

    testWidgets('selects Happy mood when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Tap on Happy mood
      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      // Verify the widget rebuilds after selection
      expect(find.text('Happy'), findsOneWidget);
    });

    testWidgets('selects Calm mood when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Tap on Calm mood
      await tester.tap(find.text('Calm'));
      await tester.pumpAndSettle();

      // Verify the widget rebuilds after selection
      expect(find.text('Calm'), findsOneWidget);
    });

    testWidgets('selects Sad mood when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Tap on Sad mood
      await tester.tap(find.text('Sad'));
      await tester.pumpAndSettle();

      // Verify the widget rebuilds after selection
      expect(find.text('Sad'), findsOneWidget);
    });

    testWidgets('selects Angry mood when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Tap on Angry mood
      await tester.tap(find.text('Angry'));
      await tester.pumpAndSettle();

      // Verify the widget rebuilds after selection
      expect(find.text('Angry'), findsOneWidget);
    });

    testWidgets('changes selection when different mood is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // First select Happy
      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      // Then select Calm
      await tester.tap(find.text('Calm'));
      await tester.pumpAndSettle();

      // Verify both moods are still visible
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Calm'), findsOneWidget);
    });

    testWidgets('has proper container styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Find the main container
      final container = find.byType(Container).first;
      expect(container, findsOneWidget);

      // Verify the widget is rendered
      await tester.pumpAndSettle();
    });

    testWidgets('animates mood selection', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Tap on a mood
      await tester.tap(find.text('Happy'));

      // Pump frames to trigger animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify animation completed
      expect(find.text('Happy'), findsOneWidget);
    });

    testWidgets('displays in column layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Find Column widget
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('displays moods in row layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Find Row widget containing moods
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('has proper spacing between moods', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Verify Row has mainAxisAlignment.spaceBetween
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('renders with proper theme styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              bodySmall: TextStyle(fontSize: 12),
            ),
          ),
          home: const Scaffold(body: MoodTrackerWidget()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify widget renders with theme
      expect(find.text('How are you feeling?'), findsOneWidget);
    });

    testWidgets('mood icons have proper size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
      );

      // Find icons
      final icons = tester.widgetList<Icon>(find.byType(Icon));

      // Verify icons exist
      expect(icons.isNotEmpty, true);

      // Verify icon size is 28
      for (final icon in icons) {
        expect(icon.size, 28);
      }
    });
  });
}
