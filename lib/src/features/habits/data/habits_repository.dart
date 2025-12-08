import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/habit.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final habitsRepositoryProvider = Provider<IHabitsRepository>((ref) {
  return HabitsRepository(HiveService.habitsBox);
});

class HabitsRepository implements IHabitsRepository {
  final Box<Habit> _box;

  HabitsRepository(this._box);

  @override
  Future<List<Habit>> getHabits() async {
    return _box.values.toList();
  }

  @override
  Stream<List<Habit>> watchHabits() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    await _box.put(habit.id, habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
}

extension StreamStartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
