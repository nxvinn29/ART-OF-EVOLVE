import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/habit.dart';
import '../../../core/data/repository_interfaces.dart';
import '../data/habits_repository.dart';
import '../../../services/notifications/notification_service.dart';
import '../../gamification/presentation/gamification_controller.dart';

/// Provider for the [HabitsController].
final habitsProvider =
    StateNotifierProvider<HabitsController, AsyncValue<List<Habit>>>((ref) {
      final repository = ref.watch(habitsRepositoryProvider);
      final notificationService =
          NotificationService(); // In real app, maybe provider
      return HabitsController(repository, notificationService, ref);
    });

/// Controller for managing habits.
///
/// This controller handles creating, updating (completion status), and deleting habits.
/// It also integrates with [NotificationService] for reminders and
/// [GamificationController] to award XP and unlock badges.
/// Controller for managing habits.
///
/// This controller handles:
/// - Loading habits from [IHabitsRepository].
/// - Creating new habits with optional reminders.
/// - Toggling completion status for a given date.
/// - Deleting habits.
/// - Integrating with [NotificationService] for reminders.
/// - Integrating with [GamificationController] for XP awards.
class HabitsController extends StateNotifier<AsyncValue<List<Habit>>> {
  final IHabitsRepository _repository;
  final INotificationService _notificationService;
  final Ref _ref;

  /// Creates a [HabitsController].
  ///
  /// Requires:
  /// - [_repository]: Data source for habits.
  /// - [_notificationService]: Service for scheduling reminders.
  /// - [_ref]: Riverpod ref for interacting with other providers (e.g., Gamification).
  HabitsController(this._repository, this._notificationService, this._ref)
    : super(const AsyncLoading()) {
    loadHabits();
  }

  /// Loads all habits from the repository.
  ///
  /// Updates the state to [AsyncData] with the list of habits, or [AsyncError] on failure.
  Future<void> loadHabits() async {
    try {
      final habits = await _repository.getHabits();
      state = AsyncData(habits);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Adds a new habit with the given [title] and optional details.
  ///
  /// If a [reminderTime] is provided, a daily notification is scheduled.
  /// Triggers a reload of habits after saving.
  Future<void> addHabit(
    String title, {
    String description = '',
    TimeOfDay? reminderTime,
  }) async {
    try {
      DateTime? reminderDateTime;
      if (reminderTime != null) {
        final now = DateTime.now();
        reminderDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          reminderTime.hour,
          reminderTime.minute,
        );
      }

      final habit = Habit(
        title: title,
        description: description,
        color: 0xFF6B4EFF, // Default purple
        iconCodePoint: 0xe87f, // Default icon
        reminderTime: reminderDateTime,
      );

      await _repository.saveHabit(habit);

      if (reminderTime != null) {
        // Schedule notification
        await _notificationService.scheduleDailyNotification(
          id: habit.id.hashCode,
          title: 'Time for $title',
          body: 'Don\'t forget your daily habit!',
          time: reminderTime,
        );
      }

      // Gamification: Add XP for creating a habit (optional)
      // await _ref.read(gamificationControllerProvider.notifier).addXp(10);

      await loadHabits();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Updates an existing [habit] in the repository.
  ///
  /// This will overwrite any existing data for the habit with the same ID.
  /// After a successful update, it triggers a full reload of the habits list
  /// to ensure the UI reflects the changes.
  ///
  /// Throws an exception if the repository update fails, which is caught
  /// and updates the state to [AsyncError].
  Future<void> updateHabit(Habit habit) async {
    try {
      await _repository.saveHabit(habit);
      await loadHabits();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Toggles the completion status of a habit identified by [habitId] for a specific [date].
  ///
  /// This method performs the following:
  /// 1. Retrieves the current list of habits.
  /// 2. Finds the target habit and toggles the presence of [date] in its `completedDates`.
  /// 3. Saves the updated habit back to the repository.
  /// 4. If the habit was just marked as completed, it awards 10 XP and checks
  ///    for any newly unlocked badges via the [GamificationController].
  /// 5. Triggers a reload of habits to update the state.
  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    try {
      final habits = await _repository.getHabits();
      final habit = habits.firstWhere((h) => h.id == habitId);

      final isCompleted = habit.isCompletedOn(date);
      final newDates = List<DateTime>.from(habit.completedDates);

      if (isCompleted) {
        newDates.removeWhere(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );
      } else {
        newDates.add(date);
      }

      final updatedHabit = Habit(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        color: habit.color,
        iconCodePoint: habit.iconCodePoint,
        createdAt: habit.createdAt,
        isDaily: habit.isDaily,
        completedDates: newDates,
        reminderTime: habit.reminderTime,
      );

      await _repository.saveHabit(updatedHabit);

      // Gamification Logic
      if (!isCompleted) {
        // Was not completed, so it IS completed now.
        // Check if date is today for "daily" credit logic consistency,
        // OR just give credit for doing it.
        // For simplicity, we assume checking off today counts.
        final now = DateTime.now();
        final isToday =
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        await _ref
            .read(gamificationControllerProvider.notifier)
            .checkUnlockConditions(isToday);
        await _ref
            .read(gamificationControllerProvider.notifier)
            .addXp(10); // 10 XP per habit
      }

      await loadHabits();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Deletes the habit with the specified [id] from the repository.
  ///
  /// This action removes the habit and all its associated completion history.
  /// It also implicitly cancels any scheduled notifications for this habit.
  /// After deletion, the habits list is reloaded to update the UI state.
  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
    await loadHabits();
  }
}
