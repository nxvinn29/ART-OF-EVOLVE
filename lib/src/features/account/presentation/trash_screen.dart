import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../todos/presentation/todos_controller.dart';

/// A screen that displays soft-deleted todos.
///
/// Allows the user to restore deleted todos or permanently delete them.
/// Uses [deletedTodosProvider] to fetch the data.
class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need a way to get *deleted* todos.
    // Usually the provider filters them out.
    // We might need a specific provider for deleted items or access the raw list.
    // For now, let's assume valid implementation in controller to expose deleted items.
    // Or we extend the controller to have a `deletedTodosProvider`.

    // Using a specific provider if available, or filtering locally if the main provider returns all (which it shouldn't for the main view).
    // Let's rely on adding a `deletedTodosProvider` in the controller file or accessing a method.
    // For simplicity in this step, I'll access the notifier and ask for deleted ones,
    // but standard Riverpod `watch` is best.
    // Let's assume `todosProvider` returns *active* todos.
    // I will add `deletedTodosProvider` to `todos_controller.dart` next.
    final deletedTodosAsync = ref.watch(deletedTodosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        title: const Text(
          'Trash',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: deletedTodosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Trash is empty',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.restore, color: Colors.green),
                        onPressed: () {
                          ref.read(todosProvider.notifier).restoreTodo(todo.id);
                        },
                        tooltip: 'Restore',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Confirm dialog?
                          ref
                              .read(todosProvider.notifier)
                              .deletePermanently(todo.id);
                        },
                        tooltip: 'Delete Forever',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
