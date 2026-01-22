import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/water_tracker_widget.dart';

void main() {
  testWidgets('WaterTrackerWidget displays initial state and updates on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: WaterTrackerWidget())),
      ),
    );

    // Initial state
    expect(find.text('Water Intake'), findsOneWidget);
    expect(find.text('0 / 8 glasses'), findsOneWidget);

    // Tap Add
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1 / 8 glasses'), findsOneWidget);

    // Tap Add again
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('2 / 8 glasses'), findsOneWidget);

    // Tap Remove
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('1 / 8 glasses'), findsOneWidget);
  });

  testWidgets('WaterTrackerWidget does not go below 0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: WaterTrackerWidget())),
      ),
    );

    // Initial state 0
    expect(find.text('0 / 8 glasses'), findsOneWidget);

    // Tap Remove
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Should still be 0
    expect(find.text('0 / 8 glasses'), findsOneWidget);
  });

  testWidgets('WaterTrackerWidget displays Goal Reached when intake >= 8', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: WaterTrackerWidget())),
      ),
    );

    // Initial state 0
    expect(find.text('0 / 8 glasses'), findsOneWidget);

    // Increment to 8
    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    }

    // Verify Goal Reached message
    expect(find.text('Goal Reached! 💧'), findsOneWidget);
    expect(find.text('8 / 8 glasses'), findsNothing);

    // Increment to 9 - should still show Goal Reached
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('Goal Reached! 💧'), findsOneWidget);
  });
}
