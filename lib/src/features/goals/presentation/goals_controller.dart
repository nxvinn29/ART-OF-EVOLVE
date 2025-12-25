import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/goal.dart';
import '../data/goal_repository.dart';
import '../../../core/data/repository_interfaces.dart';

/// Provider for the [GoalsController].
final goalsProvider =
    StateNotifierProvider<GoalsController, AsyncValue<List<Goal>>>((ref) {
      final repository = ref.watch(goalRepositoryProvider);
      return GoalsController(repository);
    });

/// Controller for managing the list of user goals.
///
/// This controller handles loading, adding, toggling (achievement status),
/// and deleting goals using the [IGoalsRepository].
class GoalsController extends StateNotifier<AsyncValue<List<Goal>>> {
  final IGoalsRepository _repository;

  GoalsController(this._repository) : super(const AsyncLoading()) {
    loadGoals();
  }

  /// Loads goals from the repository.
  ///
  /// Goals are sorted by [targetDate] in ascending order.
  /// Updates the state to [AsyncData] with the list of goals, or [AsyncError] on failure.
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

  /// Adds a new goal with the given [title], [targetDate], and optional [description].
  ///
  /// After adding, reloads the goals list.
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

  /// Toggles the 'achieved' status of the goal with the specified [id].
  ///
  /// Finds the goal, flips its status, saves it, and reloads the list.
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

  /// Deletes the goal with the specified [id].
  ///
  /// After deleting, reloads the goals list.
  Future<void> deleteGoal(String id) async {
    try {
      await _repository.deleteGoal(id);
      await loadGoals();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
