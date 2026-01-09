import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/goal.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final goalRepositoryProvider = Provider<IGoalsRepository>((ref) {
  return GoalRepository(HiveService.goalsBox);
});

/// Implementation of [IGoalsRepository] using Hive for local storage.
///
/// This repository provides persistent storage for user goals using Hive,
/// a lightweight and fast key-value database for Flutter applications.
///
/// ## Features:
/// - Asynchronous CRUD operations for goals
/// - Automatic persistence to local storage
/// - Type-safe storage using Hive's type adapters
///
/// ## Usage:
/// ```dart
/// final repository = ref.watch(goalRepositoryProvider);
/// final goals = await repository.getGoals();
/// ```
///
/// ## Storage Details:
/// - Goals are stored using their unique ID as the key
/// - All operations are asynchronous to prevent UI blocking
/// - Data persists across app sessions
class GoalRepository implements IGoalsRepository {
  /// The Hive box instance used for storing goals.
  final Box<Goal> _box;

  /// Creates a [GoalRepository] with the given Hive [_box].
  ///
  /// [_box] An initialized Hive box configured to store [Goal] objects.
  GoalRepository(this._box);

  /// Retrieves all goals from the storage.
  ///
  /// Returns a [List] of all stored goals.
  /// The list is a snapshot of the current state.
  @override
  Future<List<Goal>> getGoals() async {
    return _box.values.toList();
  }

  /// Saves or updates a [goal] in storage.
  ///
  /// [goal] The goal object to save. Must have a valid unique ID.
  ///
  /// If a goal with the same ID already exists, it will be replaced.
  /// Otherwise, a new entry is created.
  ///
  /// Throws [HiveError] if the box is not open or if serialization fails.
  @override
  Future<void> saveGoal(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  /// Deletes a goal by its [id].
  ///
  /// [id] The unique identifier of the goal to delete.
  ///
  /// Removes the goal with the specified ID from storage. If no goal
  /// with the given ID exists, this operation completes without error.
  ///
  /// Throws [HiveError] if the box is not open.
  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }
}
