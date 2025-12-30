import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/habit.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final habitsRepositoryProvider = Provider<IHabitsRepository>((ref) {
  return HabitsRepository(HiveService.habitsBox);
});

/// Repository for managing habit data persistence using Hive.
///
/// This repository provides CRUD operations for [Habit] entities and
/// implements reactive data access through streams. It serves as the
/// single source of truth for habit data in the application.
///
/// Example usage:
/// ```dart
/// final repository = HabitsRepository(HiveService.habitsBox);
/// final habits = await repository.getHabits();
/// ```
class HabitsRepository implements IHabitsRepository {
  /// The Hive box used for storing habit data.
  final Box<Habit> _box;

  /// Creates a [HabitsRepository] with the given Hive [_box].
  ///
  /// The box should be properly initialized before passing it to this constructor.
  HabitsRepository(this._box);

  /// Retrieves all habits from local storage.
  ///
  /// Returns a [Future] that completes with a list of all stored [Habit] objects.
  /// The list will be empty if no habits have been created yet.
  ///
  /// This method performs a one-time read. For reactive updates, use [watchHabits].
  @override
  Future<List<Habit>> getHabits() async {
    return _box.values.toList();
  }

  /// Watches for changes to the habits collection.
  ///
  /// Returns a [Stream] that emits the complete list of habits whenever
  /// any habit is added, updated, or deleted. The stream immediately emits
  /// the current state using [startWith], ensuring subscribers receive
  /// data without waiting for the first change.
  ///
  /// This is useful for building reactive UIs that automatically update
  /// when habit data changes.
  ///
  /// Example:
  /// ```dart
  /// repository.watchHabits().listen((habits) {
  ///   print('Habits updated: ${habits.length}');
  /// });
  /// ```
  @override
  Stream<List<Habit>> watchHabits() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  /// Saves a habit to local storage.
  ///
  /// If a habit with the same [Habit.id] already exists, it will be updated.
  /// Otherwise, a new habit entry is created.
  ///
  /// The operation is asynchronous and completes when the data is persisted.
  ///
  /// Example:
  /// ```dart
  /// final habit = Habit(
  ///   title: 'Morning Exercise',
  ///   color: Colors.blue.value,
  ///   iconCodePoint: Icons.fitness_center.codePoint,
  /// );
  /// await repository.saveHabit(habit);
  /// ```
  @override
  Future<void> saveHabit(Habit habit) async {
    await _box.put(habit.id, habit);
  }

  /// Deletes a habit from local storage by its ID.
  ///
  /// If no habit with the given [id] exists, this operation completes
  /// without error.
  ///
  /// The operation is asynchronous and completes when the data is removed.
  ///
  /// Example:
  /// ```dart
  /// await repository.deleteHabit('habit-id-123');
  /// ```
  @override
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
}

/// Extension to add [startWith] functionality to streams.
///
/// This extension allows a stream to immediately emit an initial value
/// before emitting values from the original stream.
extension StreamStartWith<T> on Stream<T> {
  /// Prepends an initial [value] to this stream.
  ///
  /// The returned stream will first emit [value], then emit all values
  /// from the original stream.
  ///
  /// Example:
  /// ```dart
  /// Stream.periodic(Duration(seconds: 1), (i) => i)
  ///   .startWith(-1)
  ///   .listen(print); // Prints: -1, 0, 1, 2, ...
  /// ```
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
