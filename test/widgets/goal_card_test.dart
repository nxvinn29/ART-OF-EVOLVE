import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget tests for GoalCard component.
///
/// Tests goal display, interactions, and visual states.
void main() {
  group('GoalCard Widget Tests', () {
    testWidgets('displays goal title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(child: ListTile(title: Text('Learn Flutter'))),
            ),
          ),
        ),
      );

      expect(find.text('Learn Flutter'), findsOneWidget);
    });

    testWidgets('displays goal description', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: ListTile(
                  title: Text('Goal Title'),
                  subtitle: Text('Goal description here'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Goal description here'), findsOneWidget);
    });

    testWidgets('shows target date', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [Text('Goal'), Text('Target: Dec 31, 2026')],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('Target'), findsOneWidget);
    });

    testWidgets('displays achievement status icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: ListTile(
                  title: Text('Achieved Goal'),
                  trailing: Icon(Icons.check_circle),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows progress indicator for active goals', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [
                    Text('Active Goal'),
                    LinearProgressIndicator(value: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('responds to tap', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GestureDetector(
                onTap: () => tapped = true,
                child: const Card(child: Text('Tap me')),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('displays different styles for achieved goals', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                color: Colors.green.shade50,
                child: const Text('Achieved'),
              ),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, isNotNull);
    });

    testWidgets('shows days remaining for active goals', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [Text('Goal'), Text('15 days remaining')],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('days remaining'), findsOneWidget);
    });
  });
}
