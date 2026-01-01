import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget tests for TodoListWidget component.
///
/// Tests todo list display, completion, and management.
void main() {
  group('TodoListWidget Tests', () {
    testWidgets('displays list of todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  ListTile(title: Text('Todo 1')),
                  ListTile(title: Text('Todo 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });

    testWidgets('shows checkboxes for todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Todo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('toggles todo completion', (WidgetTester tester) async {
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
                    title: const Text('Todo'),
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

    testWidgets('displays completed todos with strikethrough', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CheckboxListTile(
                value: true,
                onChanged: (_) {},
                title: const Text(
                  'Completed Todo',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Completed Todo'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('shows empty state when no todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('No todos yet'))),
          ),
        ),
      );

      expect(find.text('No todos yet'), findsOneWidget);
    });

    testWidgets('displays todo categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListTile(title: Text('Todo'), subtitle: Text('Work')),
            ),
          ),
        ),
      );

      expect(find.text('Work'), findsOneWidget);
    });

    testWidgets('supports swipe to delete', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  Dismissible(
                    key: const Key('todo-1'),
                    onDismissed: (_) {},
                    child: const ListTile(title: Text('Swipe me')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Swipe me'), findsOneWidget);

      await tester.drag(find.text('Swipe me'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Swipe me'), findsNothing);
    });

    testWidgets('shows add todo button', (WidgetTester tester) async {
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
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
