import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/todo.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

/// Provider for accessing the [TodoRepository] instance.
///
/// This provider creates and manages a singleton instance of [TodoRepository]
/// configured with the Hive todos box.
final todoRepositoryProvider = Provider<ITodosRepository>((ref) {
  return TodoRepository(HiveService.todosBox);
});

/// Implementation of [ITodosRepository] using Hive for local storage.
///
/// This repository provides persistent storage for user todos using Hive,
/// a lightweight and fast key-value database for Flutter applications.
///
/// ## Features:
/// - Asynchronous CRUD operations for todos
/// - Real-time updates via Stream
/// - Automatic persistence to local storage
/// - Support for soft deletion tracking
///
/// ## Usage:
/// ```dart
/// final repository = ref.watch(todoRepositoryProvider);
/// final todos = await repository.getTodos();
/// ```
class TodoRepository implements ITodosRepository {
  /// The Hive box instance used for storing todos.
  ///
  /// This box is initialized by [HiveService] and contains all user todos.
  final Box<Todo> _box;

  /// Creates a [TodoRepository] with the given Hive [_box].
  ///
  /// The [_box] parameter should be an initialized Hive box configured
  /// to store [Todo] objects. Typically obtained from [HiveService.todosBox].
  ///
  /// Example:
  /// ```dart
  /// final repository = TodoRepository(HiveService.todosBox);
  /// ```
  TodoRepository(this._box);

  /// Retrieves all todos from storage.
  ///
  /// Returns a [Future] that completes with a [List] of all stored todos,
  /// including soft-deleted items. Use filtering to exclude deleted todos.
  ///
  /// ## Returns:
  /// A list of all todos currently stored in the database. Returns an empty
  /// list if no todos exist.
  ///
  /// ## Example:
  /// ```dart
  /// final todos = await repository.getTodos();
  /// final activeTodos = todos.where((t) => !t.isDeleted).toList();
  /// ```
  @override
  Future<List<Todo>> getTodos() async {
    return _box.values.toList();
  }

  /// Watches for changes to todos in real-time.
  ///
  /// Returns a [Stream] that emits the complete list of todos whenever
  /// any todo is added, modified, or deleted. The stream starts by
  /// emitting the current state immediately.
  ///
  /// ## Returns:
  /// A stream of todo lists that updates on any change to the todos box.
  ///
  /// ## Example:
  /// ```dart
  /// repository.watchTodos().listen((todos) {
  ///   print('Todos updated: ${todos.length} items');
  /// });
  /// ```
  ///
  /// ## Performance:
  /// The stream emits the entire list on each change. For large datasets,
  /// consider implementing incremental updates.
  @override
  Stream<List<Todo>> watchTodos() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  /// Saves or updates a [todo] in storage.
  ///
  /// If a todo with the same ID already exists, it will be replaced.
  /// Otherwise, a new entry is created.
  ///
  /// ## Parameters:
  /// - [todo]: The todo object to save. Must have a valid unique ID.
  ///
  /// ## Behavior:
  /// - Uses the todo's ID as the storage key
  /// - Overwrites existing todos with the same ID
  /// - Persists changes immediately to disk
  /// - Triggers updates to [watchTodos] stream
  ///
  /// ## Example:
  /// ```dart
  /// final todo = Todo(
  ///   title: 'Buy groceries',
  ///   category: 'Personal',
  /// );
  /// await repository.saveTodo(todo);
  /// ```
  @override
  Future<void> saveTodo(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  /// Deletes a todo by its [id].
  ///
  /// Permanently removes the todo with the specified ID from storage.
  /// If no todo with the given ID exists, this operation completes without error.
  ///
  /// ## Parameters:
  /// - [id]: The unique identifier of the todo to delete.
  ///
  /// ## Behavior:
  /// - Idempotent: safe to call multiple times with the same ID
  /// - Changes persist immediately to disk
  /// - Triggers updates to [watchTodos] stream
  /// - Does not throw if the todo doesn't exist
  ///
  /// ## Example:
  /// ```dart
  /// await repository.deleteTodo('todo-123');
  /// ```
  ///
  /// ## Note:
  /// For soft deletion, use [saveTodo] with `isDeleted: true` instead.
  @override
  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}

extension StreamStartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
