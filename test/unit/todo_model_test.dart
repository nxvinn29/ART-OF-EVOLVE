import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';

/// Unit tests for the [Todo] model.
///
/// Tests todo creation, completion logic, soft deletion, and category management.
void main() {
  group('Todo Model Tests', () {
    test('creates todo with required fields', () {
      final todo = Todo(title: 'Buy groceries');

      expect(todo.title, 'Buy groceries');
      expect(todo.isCompleted, false);
      expect(todo.isDeleted, false);
      expect(todo.category, 'General');
      expect(todo.id, isNotEmpty);
      expect(todo.createdAt, isNotNull);
      expect(todo.deletedAt, isNull);
    });

    test('creates todo with custom id', () {
      const customId = 'custom-todo-123';
      final todo = Todo(id: customId, title: 'Custom Todo');

      expect(todo.id, customId);
    });

    test('creates completed todo', () {
      final todo = Todo(title: 'Completed Task', isCompleted: true);

      expect(todo.isCompleted, true);
    });

    test('creates todo with custom category', () {
      final todo = Todo(title: 'Work Task', category: 'Work');

      expect(todo.category, 'Work');
    });

    test('creates todo with custom createdAt date', () {
      final customDate = DateTime(2026, 1, 1);
      final todo = Todo(title: 'Test Todo', createdAt: customDate);

      expect(todo.createdAt, customDate);
    });

    test('creates soft-deleted todo', () {
      final deletedDate = DateTime.now();
      final todo = Todo(
        title: 'Deleted Todo',
        isDeleted: true,
        deletedAt: deletedDate,
      );

      expect(todo.isDeleted, true);
      expect(todo.deletedAt, deletedDate);
    });

    test('copyWith updates title', () {
      final original = Todo(title: 'Original Title');
      final updated = original.copyWith(title: 'Updated Title');

      expect(updated.title, 'Updated Title');
      expect(updated.id, original.id);
      expect(updated.isCompleted, original.isCompleted);
    });

    test('copyWith updates isCompleted', () {
      final original = Todo(title: 'Task', isCompleted: false);
      final completed = original.copyWith(isCompleted: true);

      expect(completed.isCompleted, true);
      expect(original.isCompleted, false);
    });

    test('copyWith updates category', () {
      final original = Todo(title: 'Task', category: 'General');
      final updated = original.copyWith(category: 'Work');

      expect(updated.category, 'Work');
      expect(original.category, 'General');
    });

    test('copyWith updates isDeleted', () {
      final original = Todo(title: 'Task', isDeleted: false);
      final deleted = original.copyWith(isDeleted: true);

      expect(deleted.isDeleted, true);
      expect(original.isDeleted, false);
    });

    test('copyWith updates deletedAt', () {
      final deleteDate = DateTime.now();
      final original = Todo(title: 'Task');
      final deleted = original.copyWith(deletedAt: deleteDate);

      expect(deleted.deletedAt, deleteDate);
      expect(original.deletedAt, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final original = Todo(
        title: 'Original Task',
        category: 'Work',
        isCompleted: false,
      );
      final updated = original.copyWith(title: 'New Title');

      expect(updated.title, 'New Title');
      expect(updated.category, original.category);
      expect(updated.isCompleted, original.isCompleted);
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
    });

    test('generates unique ids for different todos', () {
      final todo1 = Todo(title: 'Task 1');
      final todo2 = Todo(title: 'Task 2');

      expect(todo1.id, isNot(equals(todo2.id)));
    });

    test('can mark incomplete todo as complete', () {
      final todo = Todo(title: 'Task', isCompleted: false);
      final completed = todo.copyWith(isCompleted: true);

      expect(todo.isCompleted, false);
      expect(completed.isCompleted, true);
    });

    test('can mark complete todo as incomplete', () {
      final todo = Todo(title: 'Task', isCompleted: true);
      final incomplete = todo.copyWith(isCompleted: false);

      expect(todo.isCompleted, true);
      expect(incomplete.isCompleted, false);
    });

    test('can soft delete a todo', () {
      final todo = Todo(title: 'Task');
      final deleteDate = DateTime.now();
      final deleted = todo.copyWith(isDeleted: true, deletedAt: deleteDate);

      expect(deleted.isDeleted, true);
      expect(deleted.deletedAt, deleteDate);
    });

    test('can restore soft-deleted todo', () {
      final todo = Todo(
        title: 'Task',
        isDeleted: true,
        deletedAt: DateTime.now(),
      );
      final restored = todo.copyWith(isDeleted: false, deletedAt: null);

      expect(restored.isDeleted, false);
      expect(restored.deletedAt, isNull);
    });

    test('copyWith with no parameters returns equivalent todo', () {
      final original = Todo(
        title: 'Test Task',
        category: 'Work',
        isCompleted: true,
      );
      final copy = original.copyWith();

      expect(copy.title, original.title);
      expect(copy.category, original.category);
      expect(copy.isCompleted, original.isCompleted);
      expect(copy.id, original.id);
      expect(copy.createdAt, original.createdAt);
    });

    test('createdAt is set to current time when not provided', () {
      final beforeCreation = DateTime.now();
      final todo = Todo(title: 'Test Task');
      final afterCreation = DateTime.now();

      expect(
        todo.createdAt.isAfter(
          beforeCreation.subtract(const Duration(seconds: 1)),
        ),
        true,
      );
      expect(
        todo.createdAt.isBefore(afterCreation.add(const Duration(seconds: 1))),
        true,
      );
    });

    test('can change category multiple times', () {
      final original = Todo(title: 'Task', category: 'General');
      final work = original.copyWith(category: 'Work');
      final personal = work.copyWith(category: 'Personal');

      expect(original.category, 'General');
      expect(work.category, 'Work');
      expect(personal.category, 'Personal');
    });

    test('completed and deleted states are independent', () {
      final todo = Todo(title: 'Task', isCompleted: true, isDeleted: true);

      expect(todo.isCompleted, true);
      expect(todo.isDeleted, true);
    });

    test('can complete a deleted todo', () {
      final todo = Todo(title: 'Task', isDeleted: true);
      final completed = todo.copyWith(isCompleted: true);

      expect(completed.isCompleted, true);
      expect(completed.isDeleted, true);
    });

    test('multiple copyWith calls maintain data integrity', () {
      final original = Todo(
        title: 'Original',
        category: 'General',
        isCompleted: false,
      );

      final step1 = original.copyWith(title: 'Step 1');
      final step2 = step1.copyWith(category: 'Work');
      final step3 = step2.copyWith(isCompleted: true);

      expect(step3.title, 'Step 1');
      expect(step3.category, 'Work');
      expect(step3.isCompleted, true);
      expect(step3.id, original.id);
    });

    test('default category is General', () {
      final todo = Todo(title: 'Task');
      expect(todo.category, 'General');
    });

    test('can create todo with empty title', () {
      final todo = Todo(title: '');
      expect(todo.title, '');
    });

    test('deletedAt can be null for non-deleted todos', () {
      final todo = Todo(title: 'Task', isDeleted: false);
      expect(todo.deletedAt, isNull);
    });

    test('can set deletedAt without setting isDeleted', () {
      final deleteDate = DateTime.now();
      final todo = Todo(title: 'Task', deletedAt: deleteDate);

      expect(todo.deletedAt, deleteDate);
      expect(todo.isDeleted, false);
    });
  });
}
