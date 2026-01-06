import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/mini_todo_list_widget.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/todos/presentation/todos_controller.dart';

void main() {
  testWidgets('MiniTodoListWidget shows empty state when no active todos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTodosProvider.overrideWith((ref) => const AsyncData([])),
        ],
        child: const MaterialApp(home: Scaffold(body: MiniTodoListWidget())),
      ),
    );

    expect(find.text('All caught up! 🎉'), findsOneWidget);
  });

  testWidgets('MiniTodoListWidget shows active todos', (
    WidgetTester tester,
  ) async {
    final todos = [
      Todo(id: '1', title: 'Task 1', isCompleted: false),
      Todo(id: '2', title: 'Task 2', isCompleted: false),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTodosProvider.overrideWith((ref) => AsyncData(todos)),
        ],
        child: const MaterialApp(home: Scaffold(body: MiniTodoListWidget())),
      ),
    );

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
  });

  // Note: Testing interactions (tap checkbox/delete) requires mocking the notifier
  // referenced by todosProvider.notifier.
  // ref.read(todosProvider.notifier).toggleTodo(...)
  // This is harder to mock without a full mock controller or overriding todosProvider with a mock notifier.
  // For this step, verifying rendering is sufficient for "contributions".
}
