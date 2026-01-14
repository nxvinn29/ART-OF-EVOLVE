import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/features/todos/data/todo_repository.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';

// Manual mock for Hive Box
class MockBox<T> extends Fake implements Box<T> {
  final Map<dynamic, T> _data = {};
  final _controller = StreamController<BoxEvent>.broadcast();

  @override
  T? get(dynamic key, {T? defaultValue}) => _data[key] ?? defaultValue;

  @override
  Future<void> put(dynamic key, T value) async {
    _data[key] = value;
    _controller.add(BoxEvent(key, value, false));
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
    _controller.add(BoxEvent(key, null, true));
  }

  @override
  Iterable<T> get values => _data.values;

  @override
  Stream<BoxEvent> watch({dynamic key}) {
    return _controller.stream;
  }
}

void main() {
  late MockBox<Todo> mockBox;
  late TodoRepository repository;

  setUp(() {
    mockBox = MockBox<Todo>();
    repository = TodoRepository(mockBox);
  });

  group('TodoRepository', () {
    test('getTodos returns empty list when no todos exist', () async {
      // Act
      final result = await repository.getTodos();

      // Assert
      expect(result, isEmpty);
    });

    test('saveTodo successfully saves a todo', () async {
      // Arrange
      final todo = Todo(title: 'Buy groceries', category: 'Personal');

      // Act
      await repository.saveTodo(todo);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(1));
      expect(todos.first.title, 'Buy groceries');
      expect(todos.first.category, 'Personal');
      expect(todos.first.isCompleted, false);
    });

    test('getTodos returns all saved todos', () async {
      // Arrange
      final todo1 = Todo(title: 'Task 1', category: 'Work');
      final todo2 = Todo(title: 'Task 2', category: 'Personal');
      final todo3 = Todo(title: 'Task 3', category: 'Health');

      // Act
      await repository.saveTodo(todo1);
      await repository.saveTodo(todo2);
      await repository.saveTodo(todo3);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(3));
      expect(
        todos.map((t) => t.title),
        containsAll(['Task 1', 'Task 2', 'Task 3']),
      );
    });

    test('saveTodo updates existing todo with same ID', () async {
      // Arrange
      final todo = Todo(title: 'Original Task', category: 'Work');
      await repository.saveTodo(todo);

      final updatedTodo = todo.copyWith(
        title: 'Updated Task',
        isCompleted: true,
      );

      // Act
      await repository.saveTodo(updatedTodo);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(1));
      expect(todos.first.title, 'Updated Task');
      expect(todos.first.isCompleted, true);
    });

    test('deleteTodo removes todo successfully', () async {
      // Arrange
      final todo = Todo(title: 'Delete Me', category: 'Test');
      await repository.saveTodo(todo);

      // Act
      await repository.deleteTodo(todo.id);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, isEmpty);
    });

    test('deleteTodo handles non-existent ID gracefully', () async {
      // Arrange
      final todo = Todo(title: 'Keep Me', category: 'Important');
      await repository.saveTodo(todo);

      // Act
      await repository.deleteTodo('non-existent-id');
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(1));
      expect(todos.first.title, 'Keep Me');
    });

    test('saveTodo preserves todo ID', () async {
      // Arrange
      final todo = Todo(title: 'ID Test', category: 'Test');
      final originalId = todo.id;

      // Act
      await repository.saveTodo(todo);
      final todos = await repository.getTodos();

      // Assert
      expect(todos.first.id, originalId);
    });

    test('saveTodo handles todos with different completion states', () async {
      // Arrange
      final completed = Todo(
        title: 'Done',
        category: 'Work',
      ).copyWith(isCompleted: true);
      final pending = Todo(title: 'Pending', category: 'Personal');

      // Act
      await repository.saveTodo(completed);
      await repository.saveTodo(pending);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(2));
      expect(todos.where((t) => t.isCompleted), hasLength(1));
      expect(todos.where((t) => !t.isCompleted), hasLength(1));
    });

    test('saveTodo handles soft-deleted todos', () async {
      // Arrange
      final activeTodo = Todo(title: 'Active', category: 'Work');
      final deletedTodo = Todo(
        title: 'Deleted',
        category: 'Work',
      ).copyWith(isDeleted: true);

      // Act
      await repository.saveTodo(activeTodo);
      await repository.saveTodo(deletedTodo);
      final todos = await repository.getTodos();

      // Assert
      expect(todos, hasLength(2));
      expect(todos.where((t) => t.isDeleted), hasLength(1));
      expect(todos.where((t) => !t.isDeleted), hasLength(1));
    });

    test('multiple operations maintain data integrity', () async {
      // Arrange & Act
      final todos = List.generate(
        5,
        (i) => Todo(title: 'Todo $i', category: 'Category $i'),
      );

      // Save all
      for (var todo in todos) {
        await repository.saveTodo(todo);
      }

      // Delete some
      await repository.deleteTodo(todos[1].id);
      await repository.deleteTodo(todos[3].id);

      // Update one
      await repository.saveTodo(todos[0].copyWith(isCompleted: true));

      final result = await repository.getTodos();

      // Assert
      expect(result, hasLength(3));
      expect(result.where((t) => t.isCompleted), hasLength(1));
      expect(
        result.map((t) => t.title),
        containsAll(['Todo 0', 'Todo 2', 'Todo 4']),
      );
    });

    test('watchTodos emits updates when todos are changed', () async {
      // Arrange
      final todo1 = Todo(title: 'Watch Me 1', category: 'Test');
      final todo2 = Todo(title: 'Watch Me 2', category: 'Test');

      // Act & Assert
      // The stream sends the current state immediately (which is empty)
      expectLater(
        repository.watchTodos(),
        emitsInOrder([
          isEmpty, // Initial state
          hasLength(1), // After save todo1
          hasLength(2), // After save todo2
          hasLength(1), // After delete todo1
        ]),
      );

      await repository.saveTodo(todo1);
      await repository.saveTodo(todo2);
      await repository.deleteTodo(todo1.id);
    });
  });
}
