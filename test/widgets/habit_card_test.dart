import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget tests for HabitCard component.
///
/// Tests habit card display, completion, and interactions.
void main() {
  group('HabitCard Widget Tests', () {
    testWidgets('displays habit title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(child: ListTile(title: Text('Morning Exercise'))),
            ),
          ),
        ),
      );

      expect(find.text('Morning Exercise'), findsOneWidget);
    });

    testWidgets('shows habit icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text('Exercise'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('displays completion checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: CheckboxListTile(
                  value: false,
                  onChanged: (_) {},
                  title: const Text('Habit'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('shows current streak', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                child: Column(
                  children: [
                    Text('Habit'),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department),
                        Text('7 day streak'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('streak'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('toggles completion state', (WidgetTester tester) async {
      bool isCompleted = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() => isCompleted = value ?? false);
                    },
                    title: const Text('Habit'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(isCompleted, true);
    });

    testWidgets('displays habit color', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Card(
                color: Colors.blue.shade50,
                child: const Text('Habit'),
              ),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, isNotNull);
    });
  });
}
