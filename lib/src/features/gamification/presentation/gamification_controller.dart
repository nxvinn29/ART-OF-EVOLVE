import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/storage/hive_service.dart';
import '../../gamification/domain/user_stats.dart';

/// Provider for the [GamificationController].
final gamificationControllerProvider =
    StateNotifierProvider<GamificationController, UserStats>((ref) {
      return GamificationController();
    });

/// Controller for managing gamification logic, such as XP, levels, and badges.
///
/// This controller persists user statistics using [HiveService.userStatsBox] and handles
/// logic for leveling up (every 100 * level XP) and unlocking badges based on user activity.
class GamificationController extends StateNotifier<UserStats> {
  GamificationController() : super(UserStats()) {
    _loadStats();
  }

  /// Loads the user statistics from local storage.
  ///
  /// If no statistics are found, initializes with default values.
  void _loadStats() {
    final box = HiveService.userStatsBox;
    if (box.isNotEmpty) {
      state = box.getAt(0) ?? UserStats();
    } else {
      // Initialize if empty
      box.add(UserStats());
    }
  }

  /// Saves the current user statistics to local storage.
  Future<void> _saveStats() async {
    final box = HiveService.userStatsBox;
    await box.putAt(0, state);
  }

  /// Adds [amount] of XP to the user's current total.
  ///
  /// Checks for level-up conditions. If the user accumulates enough XP,
  /// their level is incremented and the XP is carried over.
  Future<void> addXp(int amount) async {
    var newXp = state.currentXp + amount;
    var newLevel = state.level;

    // Simple Leveling Logic: Level * 100 XP required for next level
    // e.g. Level 1 -> 100 XP to Level 2
    // Level 2 -> 200 XP to Level 3 (Cumulative)
    final xpRequired = state.level * 100;

    if (newXp >= xpRequired) {
      newXp -= xpRequired;
      newLevel++;
    }

    state = state.copyWith(currentXp: newXp, level: newLevel);
    await _saveStats();
  }

  /// Increments the count of total habits completed by the user.
  Future<void> _incrementHabitCount() async {
    state = state.copyWith(
      totalHabitsCompleted: state.totalHabitsCompleted + 1,
    );
    await _saveStats();
  }

  /// Checks if any new badges or rewards should be unlocked.
  ///
  /// This method updates the habit count if [isHabitCompletedToday] is true,
  /// and then checks for badge unlock conditions (e.g., "First Step" badge).
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {
    if (isHabitCompletedToday) {
      await _incrementHabitCount();
    }

    // Check Badges
    final newBadges = List<String>.from(state.unlockedBadgeIds);
    var badgeUnlocked = false;

    // First Step Badge
    if (state.totalHabitsCompleted >= 1 &&
        !state.unlockedBadgeIds.contains('first_step')) {
      newBadges.add('first_step');
      await addXp(50);
      badgeUnlocked = true;
    }

    if (badgeUnlocked) {
      state = state.copyWith(unlockedBadgeIds: newBadges);
      await _saveStats();
    }
  }

  /// Resets the user's statistics to their initial state.
  ///
  /// **Warning**: This action is irreversible and clears all progress.
  Future<void> resetStats() async {
    state = UserStats();
    await _saveStats();
  }
}
