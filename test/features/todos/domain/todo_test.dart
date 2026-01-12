import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';

void main() {
  group('Todo', () {
    test('initializes with correct defaults', () {
      final todo = Todo(title: 'Test Task');

      expect(todo.title, 'Test Task');
      expect(todo.isCompleted, false);
      expect(todo.isDeleted, false);
      expect(todo.category, 'General');
      expect(todo.id, isNotEmpty);
      expect(todo.createdAt, isNotNull);
      expect(todo.deletedAt, isNull);
    });

    test('initializes with provided values', () {
      final now = DateTime.now();
      final todo = Todo(
        id: '123',
        title: 'Custom Task',
        isCompleted: true,
        category: 'Work',
        createdAt: now,
      );

      expect(todo.id, '123');
      expect(todo.title, 'Custom Task');
      expect(todo.isCompleted, true);
      expect(todo.category, 'Work');
      expect(todo.createdAt, now);
    });

    test('copyWith updates fields correctly', () {
      final todo = Todo(title: 'Original');
      final updated = todo.copyWith(
        title: 'Updated',
        isCompleted: true,
        category: 'Personal',
      );

      expect(updated.id, todo.id);
      expect(updated.title, 'Updated');
      expect(updated.isCompleted, true);
      expect(updated.category, 'Personal');
      expect(updated.createdAt, todo.createdAt);
    });

    test('copyWith handles null values correctly', () {
      final todo = Todo(title: 'Original', isCompleted: true);
      final updated = todo.copyWith(title: null, isCompleted: null);

      expect(updated.title, 'Original');
      expect(updated.isCompleted, true);
    });
  });
}
