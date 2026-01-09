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

  /// Creates a new instance of [GoalsController].
  ///
  /// [repository] The repository to use for data operations.
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
      if (mounted) {
        state = AsyncData(goals);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  /// Adds a new goal.
  ///
  /// [title] The title of the goal.
  /// [targetDate] The date by which the goal should be achieved.
  /// [description] Optional description of the goal.
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

  /// Toggles the 'achieved' status of a goal.
  ///
  /// [id] The unique identifier of the goal to toggle.
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

  /// Deletes a goal.
  ///
  /// [id] The unique identifier of the goal to delete.
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
