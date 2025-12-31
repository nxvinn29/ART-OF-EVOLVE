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
  ///
  /// This box is initialized by [HiveService] and contains all user goals.
  final Box<Goal> _box;

  /// Creates a [GoalRepository] with the given Hive [_box].
  ///
  /// The [_box] parameter should be an initialized Hive box configured
  /// to store [Goal] objects. Typically obtained from [HiveService.goalsBox].
  ///
  /// Example:
  /// ```dart
  /// final repository = GoalRepository(HiveService.goalsBox);
  /// ```
  GoalRepository(this._box);

  /// Retrieves all goals from the storage.
  ///
  /// Returns a [Future] that completes with a [List] of all stored goals.
  /// The list is a snapshot of the current state and modifications to it
  /// will not affect the stored data.
  ///
  /// ## Returns:
  /// A list of all goals currently stored in the database. Returns an empty
  /// list if no goals exist.
  ///
  /// ## Example:
  /// ```dart
  /// final goals = await repository.getGoals();
  /// print('Found ${goals.length} goals');
  /// ```
  ///
  /// ## Performance:
  /// This operation is O(n) where n is the number of goals. For large
  /// datasets, consider implementing pagination or filtering.
  @override
  Future<List<Goal>> getGoals() async {
    return _box.values.toList();
  }

  /// Saves or updates a [goal] in storage.
  ///
  /// If a goal with the same ID already exists, it will be replaced.
  /// Otherwise, a new entry is created.
  ///
  /// ## Parameters:
  /// - [goal]: The goal object to save. Must have a valid unique ID.
  ///
  /// ## Behavior:
  /// - Uses the goal's ID as the storage key
  /// - Overwrites existing goals with the same ID
  /// - Persists changes immediately to disk
  ///
  /// ## Example:
  /// ```dart
  /// final goal = Goal(
  ///   title: 'Learn Flutter',
  ///   targetDate: DateTime(2025, 12, 31),
  /// );
  /// await repository.saveGoal(goal);
  /// ```
  ///
  /// ## Throws:
  /// May throw [HiveError] if the box is not open or if serialization fails.
  @override
  Future<void> saveGoal(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  /// Deletes a goal by its [id].
  ///
  /// Removes the goal with the specified ID from storage. If no goal
  /// with the given ID exists, this operation completes without error.
  ///
  /// ## Parameters:
  /// - [id]: The unique identifier of the goal to delete.
  ///
  /// ## Behavior:
  /// - Idempotent: safe to call multiple times with the same ID
  /// - Changes persist immediately to disk
  /// - Does not throw if the goal doesn't exist
  ///
  /// ## Example:
  /// ```dart
  /// await repository.deleteGoal('goal-123');
  /// ```
  ///
  /// ## Throws:
  /// May throw [HiveError] if the box is not open.
  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }
}
