import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/todos/presentation/todos_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

// Manual Mock
// Manual Mock with nullable overrides to support Mockito matchers
class MockITodosRepository extends Mock implements ITodosRepository {
  @override
  Future<void> saveTodo(Todo? todo) => super.noSuchMethod(
    Invocation.method(#saveTodo, [todo]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );

  @override
  Future<List<Todo>> getTodos() => super.noSuchMethod(
    Invocation.method(#getTodos, []),
    returnValue: Future.value(<Todo>[]),
    returnValueForMissingStub: Future.value(<Todo>[]),
  );

  @override
  Future<void> deleteTodo(String? id) => super.noSuchMethod(
    Invocation.method(#deleteTodo, [id]),
    returnValue: Future.value(),
    returnValueForMissingStub: Future.value(),
  );

  @override
  Stream<List<Todo>> watchTodos() => super.noSuchMethod(
    Invocation.method(#watchTodos, []),
    returnValue: Stream.value(<Todo>[]),
    returnValueForMissingStub: Stream.value(<Todo>[]),
  );
}

void main() {
  late MockITodosRepository mockRepository;
  late TodosController controller;

  setUp(() {
    mockRepository = MockITodosRepository();
    // Default stub for getTodos
    when(mockRepository.getTodos()).thenAnswer((_) async => []);
    controller = TodosController(mockRepository);
  });

  group('TodosController', () {
    test('loadTodos appends list to state', () async {
      final todo = Todo(title: 'Test Todo');
      when(mockRepository.getTodos()).thenAnswer((_) async => [todo]);

      // Trigger load
      await controller.loadTodos();

      expect(controller.state, isA<AsyncData>());
      expect(controller.state.value, [todo]);
    });

    test('addTodo saves to repository and reloads', () async {
      when(
        mockRepository.saveTodo(argThat(isA<Todo>())),
      ).thenAnswer((_) async => {});
      when(
        mockRepository.getTodos(),
      ).thenAnswer((_) async => [Todo(title: 'New Todo')]);

      await controller.addTodo('New Todo');

      verify(mockRepository.saveTodo(argThat(isA<Todo>()))).called(1);
      verify(mockRepository.getTodos()).called(2); // Init + Reload
      expect(controller.state.value!.first.title, 'New Todo');
    });

    test('toggleTodo updates completion status', () async {
      final todo = Todo(id: '1', title: 'Task', isCompleted: false);
      when(mockRepository.getTodos()).thenAnswer((_) async => [todo]);

      // Load initial
      await controller.loadTodos();

      // Mock save to do nothing
      when(
        mockRepository.saveTodo(argThat(isA<Todo>())),
      ).thenAnswer((_) async => {});
      // Mock getTodos to return updated
      when(
        mockRepository.getTodos(),
      ).thenAnswer((_) async => [todo.copyWith(isCompleted: true)]);

      await controller.toggleTodo('1');

      verify(
        mockRepository.saveTodo(
          argThat(predicate<Todo>((t) => t.id == '1' && t.isCompleted == true)),
        ),
      ).called(1);
    });

    test('deleteTodo performs soft delete', () async {
      final todo = Todo(id: '1', title: 'Task');
      when(mockRepository.getTodos()).thenAnswer((_) async => [todo]);
      await controller.loadTodos();

      when(
        mockRepository.saveTodo(argThat(isA<Todo>())),
      ).thenAnswer((_) async => {});
      when(mockRepository.getTodos()).thenAnswer(
        (_) async => [
          todo.copyWith(isDeleted: true, deletedAt: DateTime.now()),
        ],
      );

      await controller.deleteTodo('1');

      verify(
        mockRepository.saveTodo(
          argThat(predicate<Todo>((t) => t.id == '1' && t.isDeleted == true)),
        ),
      ).called(1);
    });

    test('deletePermanently calls delete on repository', () async {
      when(mockRepository.deleteTodo('1')).thenAnswer((_) async => {});

      await controller.deletePermanently('1');

      verify(mockRepository.deleteTodo('1')).called(1);
    });
  });
}
