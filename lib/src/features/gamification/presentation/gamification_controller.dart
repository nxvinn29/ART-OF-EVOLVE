import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/storage/hive_service.dart';
import '../../gamification/domain/user_stats.dart';

final gamificationControllerProvider =
    StateNotifierProvider<GamificationController, UserStats>((ref) {
      return GamificationController();
    });

class GamificationController extends StateNotifier<UserStats> {
  GamificationController() : super(UserStats()) {
    _loadStats();
  }

  void _loadStats() {
    final box = HiveService.userStatsBox;
    if (box.isNotEmpty) {
      state = box.getAt(0) ?? UserStats();
    } else {
      // Initialize if empty
      box.add(UserStats());
    }
  }

  Future<void> _saveStats() async {
    final box = HiveService.userStatsBox;
    await box.putAt(0, state);
  }

  Future<void> addXp(int amount) async {
    int newXp = state.currentXp + amount;
    int newLevel = state.level;

    // Simple Leveling Logic: Level * 100 XP required for next level
    // e.g. Level 1 -> 100 XP to Level 2
    // Level 2 -> 200 XP to Level 3 (Cumulative)
    int xpRequired = state.level * 100;

    if (newXp >= xpRequired) {
      newXp -= xpRequired;
      newLevel++;

    }

    state = state.copyWith(currentXp: newXp, level: newLevel);
    await _saveStats();
  }

  Future<void> _incrementHabitCount() async {
    state = state.copyWith(
      totalHabitsCompleted: state.totalHabitsCompleted + 1,
    );
    await _saveStats();
  }

  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {
    if (isHabitCompletedToday) {
      await _incrementHabitCount();
    }

    // Check Badges
    List<String> newBadges = List.from(state.unlockedBadgeIds);
    bool badgeUnlocked = false;

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

  Future<void> resetStats() async {
    state = UserStats();
    await _saveStats();
  }
}
