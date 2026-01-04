import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/todo.dart';
import '../data/todo_repository.dart';
import '../../../core/data/repository_interfaces.dart';

/// Provider for the [TodosController] containing ALL todos (including deleted ones).
final todosProvider =
    StateNotifierProvider<TodosController, AsyncValue<List<Todo>>>((ref) {
      final repository = ref.watch(todoRepositoryProvider);
      return TodosController(repository);
    });

/// Provider for active (non-deleted) todos.
final activeTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todosState = ref.watch(todosProvider);
  return todosState.whenData(
    (todos) => todos.where((t) => !t.isDeleted).toList(),
  );
});

/// Provider for soft-deleted (trash) todos.
final deletedTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todosState = ref.watch(todosProvider);
  return todosState.whenData(
    (todos) => todos.where((t) => t.isDeleted).toList(),
  );
});

/// Controller for managing [Todo] items.
///
/// This controller handles basic CRUD operations as well as soft-deletion and restoration.
/// Capabilities include:
/// - Loading todos with sorting (uncompleted first).
/// - Adding new todos.
/// - Toggling completion status.
/// - Soft deleting (move to trash).
/// - Restoring from trash.
/// - Permanent deletion.
///
/// It uses [ITodosRepository] for persistence.
class TodosController extends StateNotifier<AsyncValue<List<Todo>>> {
  final ITodosRepository _repository;

  TodosController(this._repository) : super(const AsyncLoading()) {
    loadTodos();
  }

  /// Loads all todos from the repository.
  ///
  /// Todos are sorted: uncompleted first, then by creation date.
  /// Updates the state to [AsyncData] or [AsyncError].
  Future<void> loadTodos() async {
    try {
      final todos = await _repository.getTodos();
      // Sort: Unchecked first, then by date descending (newest first for same status)
      todos.sort((a, b) {
        if (a.isCompleted == b.isCompleted) {
          return b.createdAt.compareTo(a.createdAt);
        }
        return a.isCompleted ? 1 : -1;
      });
      state = AsyncData(todos);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Adds a new todo with the specified [title] and [category].
  ///
  /// Triggers a reload of the list.
  Future<void> addTodo(String title, {String category = 'General'}) async {
    try {
      final todo = Todo(title: title, category: category);
      await _repository.saveTodo(todo);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Toggles the completion status of the todo with the given [id].
  Future<void> toggleTodo(String id) async {
    try {
      final todos = state.value!;
      final todo = todos.firstWhere((t) => t.id == id);
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await _repository.saveTodo(updatedTodo);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Soft deletes the todo with the given [id].
  ///
  /// The todo is marked as deleted and given a `deletedAt` timestamp.
  /// It is NOT removed from the database, just hidden from the active list.
  Future<void> deleteTodo(String id) async {
    try {
      final todos = state.value!;
      final todo = todos.firstWhere((t) => t.id == id);
      final updatedTodo = todo.copyWith(
        isDeleted: true,
        deletedAt: DateTime.now(),
      );
      await _repository.saveTodo(updatedTodo);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Restores a soft-deleted todo.
  ///
  /// Clears the `isDeleted` flag and `deletedAt` timestamp.
  Future<void> restoreTodo(String id) async {
    try {
      final todos = state.value!;
      final todo = todos.firstWhere((t) => t.id == id);
      final updatedTodo = todo.copyWith(isDeleted: false, deletedAt: null);
      await _repository.saveTodo(updatedTodo);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Permanently removes the todo from the repository.
  ///
  /// This action cannot be undone.
  Future<void> deletePermanently(String id) async {
    try {
      await _repository.deleteTodo(id);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
