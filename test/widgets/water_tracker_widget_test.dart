import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/water_tracker_widget.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(home: Scaffold(body: WaterTrackerWidget())),
    );
  }

  group('WaterTrackerWidget', () {
    testWidgets('renders initial state correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify title and initial count
      expect(find.text('Water Intake'), findsOneWidget);
      expect(find.text('0 / 8 glasses'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('increments water intake on add button tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1 / 8 glasses'), findsOneWidget);
    });

    testWidgets('decrements water intake on remove button tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Increment first
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('1 / 8 glasses'), findsOneWidget);

      // Decrement
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0 / 8 glasses'), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Try to decrement from 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('0 / 8 glasses'), findsOneWidget);
    });

    testWidgets('allows exceeding target', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap 9 times
      for (var i = 0; i < 9; i++) {
        await tester.tap(find.byIcon(Icons.add));
      }
      await tester.pump();

      expect(find.text('9 / 8 glasses'), findsOneWidget);
    });
  });
}
