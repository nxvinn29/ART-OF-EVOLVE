import 'package:art_of_evolve/src/features/home/presentation/widgets/mood_tracker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MoodTrackerWidget renders correctly and responds to taps', (
    WidgetTester tester,
  ) async {
    // Wrap with MaterialApp to provide Theme and Directionality
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MoodTrackerWidget())),
    );

    // Verify title text is present
    expect(find.text('How are you feeling?'), findsOneWidget);

    // Verify labels are present
    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);
    expect(find.text('Angry'), findsOneWidget);

    // Verify icons are present
    expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);
    expect(find.byIcon(Icons.spa), findsOneWidget);
    expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
    expect(find.byIcon(Icons.bolt), findsOneWidget);

    // Tap on 'Happy' to trigger interaction
    await tester.tap(find.text('Happy'));
    await tester.pumpAndSettle(); // Allow animation to complete
  });
}
