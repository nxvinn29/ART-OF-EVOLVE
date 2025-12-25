import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

void main() {
  group('UserStats', () {
    test('default constructor values', () {
      final stats = UserStats();
      expect(stats.currentXp, 0);
      expect(stats.level, 1);
      expect(stats.unlockedBadgeIds, isEmpty);
    });

    test('copyWith updates fields', () {
      final stats = UserStats();
      final newStats = stats.copyWith(level: 2, currentXp: 100);
      expect(newStats.level, 2);
      expect(newStats.currentXp, 100);
      expect(newStats.totalHabitsCompleted, 0); // Unchanged
    });
  });
}
