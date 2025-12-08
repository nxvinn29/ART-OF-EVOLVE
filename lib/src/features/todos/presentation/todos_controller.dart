import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/todo.dart';
import '../data/todo_repository.dart';
import '../../../core/data/repository_interfaces.dart';

// Provider for ACTIVE todos (filtering out deleted items)
final todosProvider =
    StateNotifierProvider<TodosController, AsyncValue<List<Todo>>>((ref) {
      final repository = ref.watch(todoRepositoryProvider);
      return TodosController(repository);
    });

// Provider for DELETED todos
final deletedTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todosState = ref.watch(todosProvider);
  return todosState.whenData((todos) {
    // We need to access the REST of the items that were filtered out?
    // Actually, distinct providers usually load data separately or the main controller holds ALL and we filter view-side.
    // However, to avoid breaking existing UI which expects 'todosProvider' to be the main list,
    // let's update 'TodosController' to hold ALL todos but expose methods/getters.
    // OR, better pattern: Controller holds ALL items, and we have `activeTodosProvider` and `deletedTodosProvider`.
    // But refactoring everything might be risky.

    // Alternative: Let TodosController manage "all" todos in state, and logic in UI filters.
    // But Hive loads everything.

    // Let's rely on the controller state containing ALL todos (including deleted) because
    // it simplifies restoring. We will filter in the UI or create derived providers.

    // Wait, if I change `todosProvider` to return ALL, the Dashboard might show deleted items unless I update it.
    // Let's filter in the `todosProvider`? No, `StateNotifier` state is what it is.

    // STRATEGY:
    // `todosProvider` (StateNotifier) holds everything.
    // `activeTodosProvider` filters for !isDeleted.
    // `deletedTodosProvider` filters for isDeleted.
    // Existing UI uses `todosProvider`. I should update existing UI to use `activeTodosProvider`.
    // BUT that requires editing multiple files.

    // ALTERNATIVE STRATEGY:
    // `todosProvider` (StateNotifier) holds everything.
    // Modify `TodosController` methods to be aware.
    // But `Dashboard` etc use `todosProvider`.

    // Let's stick to: `todosProvider` holds everything.
    // I will modify `loadTodos` to NOT filter, so it loads everything.
    // Then I create a Derived Provider `activeTodosProvider`.
    // AND I must update `Home/Dashboard/Habits`? No, just where Todos are used.
    // `MiniTodoListWidget` uses `todosProvider`. I should update it to filter or use derived provider.

    // To minimize breakage on existing code:
    // I will keep `todosProvider` as the MAIN controller but I will add a `deletedTodosProvider`
    // that fetches from repository separately? No that's inefficient.

    // Let's go with: `todosProvider` returns ALL.
    // I will update `MiniTodoListWidget` to filter `!isDeleted`.
    // `TrashScreen` will filter `isDeleted`.
    return todos.where((t) => t.isDeleted).toList();
  });
});

final activeTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todosState = ref.watch(todosProvider);
  return todosState.whenData(
    (todos) => todos.where((t) => !t.isDeleted).toList(),
  );
});

class TodosController extends StateNotifier<AsyncValue<List<Todo>>> {
  final ITodosRepository _repository;

  TodosController(this._repository) : super(const AsyncLoading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await _repository.getTodos();
      // Sort: Active first, then by date?
      // Actually standard sort: Unchecked first.

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

  Future<void> addTodo(String title, {String category = 'General'}) async {
    try {
      final todo = Todo(title: title, category: category);
      await _repository.saveTodo(todo);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

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

  // Soft Delete
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

  // Restore
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

  // Permanent Delete
  Future<void> deletePermanently(String id) async {
    try {
      await _repository.deleteTodo(id);
      await loadTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
