import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/goal.dart';
import '../data/goal_repository.dart';
import '../../../core/data/repository_interfaces.dart';

final goalsProvider =
    StateNotifierProvider<GoalsController, AsyncValue<List<Goal>>>((ref) {
      final repository = ref.watch(goalRepositoryProvider);
      return GoalsController(repository);
    });

class GoalsController extends StateNotifier<AsyncValue<List<Goal>>> {
  final IGoalsRepository _repository;

  GoalsController(this._repository) : super(const AsyncLoading()) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    try {
      final goals = await _repository.getGoals();
      // Sort by target date?
      goals.sort((a, b) => a.targetDate.compareTo(b.targetDate));
      state = AsyncData(goals);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addGoal(
    String title,
    DateTime targetDate, {
    String description = '',
  }) async {
    try {
      final goal = Goal(
        title: title,
        description: description,
        targetDate: targetDate,
      );
      await _repository.saveGoal(goal);
      await loadGoals();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleGoal(String id) async {
    try {
      final goals = state.value!;
      final goal = goals.firstWhere((g) => g.id == id);
      final updatedGoal = goal.copyWith(isAchieved: !goal.isAchieved);
      await _repository.saveGoal(updatedGoal);
      await loadGoals();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _repository.deleteGoal(id);
      await loadGoals();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
