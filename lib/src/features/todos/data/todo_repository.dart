import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/todo.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final todoRepositoryProvider = Provider<ITodosRepository>((ref) {
  return TodoRepository(HiveService.todosBox);
});

class TodoRepository implements ITodosRepository {
  final Box<Todo> _box;

  TodoRepository(this._box);

  @override
  Future<List<Todo>> getTodos() async {
    return _box.values.toList();
  }

  @override
  Stream<List<Todo>> watchTodos() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    await _box.put(todo.id, todo);
  }

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
