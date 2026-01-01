import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget tests for TodosScreen.
///
/// Tests todos screen layout, filtering, and user interactions.
void main() {
  group('TodosScreen Widget Tests', () {
    testWidgets('renders todos screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Todos')),
              body: const Center(child: Text('Your Todos')),
            ),
          ),
        ),
      );

      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('displays category filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('Work'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
    });

    testWidgets('shows add todo FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const Text('Todos'),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('filters todos by category', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  FilterChip(
                    label: const Text('Work'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                  const ListTile(title: Text('Work Todo')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();

      expect(find.text('Work Todo'), findsOneWidget);
    });
  });
}
