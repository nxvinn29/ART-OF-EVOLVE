import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/goal.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final goalRepositoryProvider = Provider<IGoalsRepository>((ref) {
  return GoalRepository(HiveService.goalsBox);
});

class GoalRepository implements IGoalsRepository {
  final Box<Goal> _box;

  GoalRepository(this._box);

  @override
  Future<List<Goal>> getGoals() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }
}
