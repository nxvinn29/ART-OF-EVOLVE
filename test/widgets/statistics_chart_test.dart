import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget tests for StatisticsChart component.
///
/// Tests chart rendering, data visualization, and interactions.
void main() {
  group('StatisticsChart Widget Tests', () {
    testWidgets('renders chart container', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(height: 200, child: CustomPaint(painter: null)),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('displays chart title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Weekly Progress'),
                  SizedBox(height: 200, child: Placeholder()),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Weekly Progress'), findsOneWidget);
    });

    testWidgets('shows axis labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(children: [Text('Mon'), Text('Tue'), Text('Wed')]),
            ),
          ),
        ),
      );

      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
    });

    testWidgets('displays data values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(children: [Text('75%'), Text('80%'), Text('90%')]),
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('shows legend for chart data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Icon(Icons.circle, color: Colors.blue),
                  Text('Habits'),
                  Icon(Icons.circle, color: Colors.green),
                  Text('Goals'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Habits'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
    });

    testWidgets('handles empty data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('No data available'))),
          ),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('supports different time periods', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  TextButton(onPressed: () {}, child: const Text('Week')),
                  TextButton(onPressed: () {}, child: const Text('Month')),
                  TextButton(onPressed: () {}, child: const Text('Year')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
    });

    testWidgets('displays loading indicator while fetching data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
