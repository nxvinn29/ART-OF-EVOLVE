import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/goal.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final goalRepositoryProvider = Provider<IGoalsRepository>((ref) {
  return GoalRepository(HiveService.goalsBox);
});

/// Implementation of [IGoalsRepository] using Hive for local storage.
class GoalRepository implements IGoalsRepository {
  final Box<Goal> _box;

  /// Creates a [GoalRepository] with the given Hive [_box].
  GoalRepository(this._box);

  /// Retrieves all goals from the storage.
  @override
  Future<List<Goal>> getGoals() async {
    return _box.values.toList();
  }

  /// Saves or updates a [goal] in storage.
  @override
  Future<void> saveGoal(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  /// Deletes a goal by its [id].
  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }
}
