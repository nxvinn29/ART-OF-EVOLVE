import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

void main() {
  group('UserStats Model Tests', () {
    test('should create UserStats with default values', () {
      final stats = UserStats();

      expect(stats.currentXp, 0);
      expect(stats.level, 1);
      expect(stats.totalHabitsCompleted, 0);
      expect(stats.currentStreak, 0);
      expect(stats.unlockedBadgeIds, isEmpty);
    });

    test('should create UserStats with custom values', () {
      final stats = UserStats(
        currentXp: 500,
        level: 5,
        totalHabitsCompleted: 42,
        currentStreak: 7,
        unlockedBadgeIds: ['first_step', 'streak_3'],
      );

      expect(stats.currentXp, 500);
      expect(stats.level, 5);
      expect(stats.totalHabitsCompleted, 42);
      expect(stats.currentStreak, 7);
      expect(stats.unlockedBadgeIds.length, 2);
      expect(stats.unlockedBadgeIds, contains('first_step'));
      expect(stats.unlockedBadgeIds, contains('streak_3'));
    });

    test('should update XP using copyWith', () {
      final stats = UserStats(currentXp: 100);
      final updated = stats.copyWith(currentXp: 250);

      expect(updated.currentXp, 250);
      expect(updated.level, stats.level);
      expect(updated.totalHabitsCompleted, stats.totalHabitsCompleted);
    });

    test('should update level using copyWith', () {
      final stats = UserStats(level: 1);
      final updated = stats.copyWith(level: 3);

      expect(updated.level, 3);
      expect(updated.currentXp, stats.currentXp);
    });

    test('should update totalHabitsCompleted using copyWith', () {
      final stats = UserStats(totalHabitsCompleted: 10);
      final updated = stats.copyWith(totalHabitsCompleted: 25);

      expect(updated.totalHabitsCompleted, 25);
      expect(updated.level, stats.level);
    });

    test('should update currentStreak using copyWith', () {
      final stats = UserStats(currentStreak: 3);
      final updated = stats.copyWith(currentStreak: 10);

      expect(updated.currentStreak, 10);
      expect(updated.totalHabitsCompleted, stats.totalHabitsCompleted);
    });

    test('should update unlockedBadgeIds using copyWith', () {
      final stats = UserStats(unlockedBadgeIds: ['first_step']);
      final updated = stats.copyWith(
        unlockedBadgeIds: ['first_step', 'streak_3', 'early_bird'],
      );

      expect(updated.unlockedBadgeIds.length, 3);
      expect(updated.unlockedBadgeIds, contains('early_bird'));
    });

    test('should update multiple fields using copyWith', () {
      final stats = UserStats();
      final updated = stats.copyWith(
        currentXp: 1000,
        level: 10,
        totalHabitsCompleted: 100,
        currentStreak: 15,
        unlockedBadgeIds: ['first_step', 'streak_3', 'streak_7'],
      );

      expect(updated.currentXp, 1000);
      expect(updated.level, 10);
      expect(updated.totalHabitsCompleted, 100);
      expect(updated.currentStreak, 15);
      expect(updated.unlockedBadgeIds.length, 3);
    });

    test(
      'should preserve original values when copyWith is called with nulls',
      () {
        final stats = UserStats(
          currentXp: 500,
          level: 5,
          totalHabitsCompleted: 50,
          currentStreak: 7,
          unlockedBadgeIds: ['first_step'],
        );

        final updated = stats.copyWith();

        expect(updated.currentXp, stats.currentXp);
        expect(updated.level, stats.level);
        expect(updated.totalHabitsCompleted, stats.totalHabitsCompleted);
        expect(updated.currentStreak, stats.currentStreak);
        expect(updated.unlockedBadgeIds, stats.unlockedBadgeIds);
      },
    );

    test('should handle XP progression scenario', () {
      var stats = UserStats();

      // Complete first habit
      stats = stats.copyWith(
        currentXp: 50,
        totalHabitsCompleted: 1,
        unlockedBadgeIds: ['first_step'],
      );

      expect(stats.currentXp, 50);
      expect(stats.totalHabitsCompleted, 1);
      expect(stats.level, 1);

      // Reach level 2 (assuming 100 XP needed)
      stats = stats.copyWith(currentXp: 150, level: 2, totalHabitsCompleted: 5);

      expect(stats.level, 2);
      expect(stats.currentXp, 150);
    });

    test('should handle streak progression scenario', () {
      var stats = UserStats();

      // Day 1
      stats = stats.copyWith(currentStreak: 1);
      expect(stats.currentStreak, 1);

      // Day 3 - unlock On Fire badge
      stats = stats.copyWith(
        currentStreak: 3,
        unlockedBadgeIds: ['first_step', 'streak_3'],
      );
      expect(stats.currentStreak, 3);
      expect(stats.unlockedBadgeIds, contains('streak_3'));

      // Day 7 - unlock Unstoppable badge
      stats = stats.copyWith(
        currentStreak: 7,
        unlockedBadgeIds: ['first_step', 'streak_3', 'streak_7'],
      );
      expect(stats.currentStreak, 7);
      expect(stats.unlockedBadgeIds, contains('streak_7'));
    });

    test('should handle streak reset scenario', () {
      final stats = UserStats(currentStreak: 10);
      final reset = stats.copyWith(currentStreak: 0);

      expect(reset.currentStreak, 0);
      expect(reset.totalHabitsCompleted, stats.totalHabitsCompleted);
    });

    test('should allow adding badges incrementally', () {
      var stats = UserStats();

      stats = stats.copyWith(unlockedBadgeIds: ['first_step']);
      expect(stats.unlockedBadgeIds.length, 1);

      stats = stats.copyWith(
        unlockedBadgeIds: [...stats.unlockedBadgeIds, 'streak_3'],
      );
      expect(stats.unlockedBadgeIds.length, 2);

      stats = stats.copyWith(
        unlockedBadgeIds: [...stats.unlockedBadgeIds, 'early_bird'],
      );
      expect(stats.unlockedBadgeIds.length, 3);
    });

    test('should handle high-level progression', () {
      final stats = UserStats(
        currentXp: 10000,
        level: 50,
        totalHabitsCompleted: 500,
        currentStreak: 100,
        unlockedBadgeIds: ['first_step', 'streak_3', 'streak_7', 'early_bird'],
      );

      expect(stats.level, 50);
      expect(stats.currentXp, 10000);
      expect(stats.totalHabitsCompleted, 500);
      expect(stats.currentStreak, 100);
      expect(stats.unlockedBadgeIds.length, 4);
    });

    test('should handle empty badge list correctly', () {
      final stats = UserStats(unlockedBadgeIds: []);
      expect(stats.unlockedBadgeIds, isEmpty);

      final updated = stats.copyWith(unlockedBadgeIds: ['first_step']);
      expect(updated.unlockedBadgeIds, isNotEmpty);
    });

    test('should maintain data integrity after multiple updates', () {
      var stats = UserStats();

      stats = stats.copyWith(currentXp: 100);
      stats = stats.copyWith(level: 2);
      stats = stats.copyWith(totalHabitsCompleted: 10);
      stats = stats.copyWith(currentStreak: 5);
      stats = stats.copyWith(unlockedBadgeIds: ['first_step']);

      expect(stats.currentXp, 100);
      expect(stats.level, 2);
      expect(stats.totalHabitsCompleted, 10);
      expect(stats.currentStreak, 5);
      expect(stats.unlockedBadgeIds, contains('first_step'));
    });

    test('should handle large integer values', () {
      final stats = UserStats(
        currentXp: 999999999,
        level: 999,
        totalHabitsCompleted: 1000000,
        currentStreak: 5000,
      );

      expect(stats.currentXp, 999999999);
      expect(stats.level, 999);
      expect(stats.totalHabitsCompleted, 1000000);
      expect(stats.currentStreak, 5000);
    });

    test('should handle very large list of unlocked badges', () {
      final largeBadgeList = List.generate(1000, (i) => 'badge_$i');
      final stats = UserStats(unlockedBadgeIds: largeBadgeList);

      expect(stats.unlockedBadgeIds.length, 1000);
      expect(stats.unlockedBadgeIds.first, 'badge_0');
      expect(stats.unlockedBadgeIds.last, 'badge_999');
    });

    test('should handle extreme integer values for XP', () {
      // 2^63 - 1 is the max for a 64-bit signed integer (Dart's int)
      const maxInt = 9223372036854775807;
      final stats = UserStats(currentXp: maxInt);

      expect(stats.currentXp, maxInt);

      final updated = stats.copyWith(currentXp: maxInt - 1);
      expect(updated.currentXp, maxInt - 1);
    });

    test('should correctly handle duplicate badge IDs', () {
      // The model takes a List<String>, which allows duplicates.
      // This test documents that behavior.
      final stats = UserStats(unlockedBadgeIds: ['badge_1', 'badge_1']);
      expect(stats.unlockedBadgeIds.length, 2);
      expect(stats.unlockedBadgeIds[0], 'badge_1');
      expect(stats.unlockedBadgeIds[1], 'badge_1');
    });
  });
}
