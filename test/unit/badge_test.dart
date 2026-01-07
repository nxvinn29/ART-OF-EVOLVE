import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/gamification/domain/badge.dart';

void main() {
  group('Badge Model Tests', () {
    test('should create a valid Badge instance', () {
      const badge = Badge(
        id: 'test_badge',
        name: 'Test Badge',
        description: 'A badge for testing',
        assetPath: 'assets/images/badges/test.png',
        xpReward: 100,
      );

      expect(badge.id, 'test_badge');
      expect(badge.name, 'Test Badge');
      expect(badge.description, 'A badge for testing');
      expect(badge.assetPath, 'assets/images/badges/test.png');
      expect(badge.xpReward, 100);
    });

    test('should have all predefined badges', () {
      expect(Badge.allBadges, isNotEmpty);
      expect(Badge.allBadges.length, 4);
    });

    test('should have First Step badge with correct properties', () {
      final firstStep = Badge.allBadges.firstWhere(
        (badge) => badge.id == 'first_step',
      );

      expect(firstStep.name, 'First Step');
      expect(firstStep.description, 'Complete your first habit.');
      expect(firstStep.assetPath, 'assets/images/badges/first_step.png');
      expect(firstStep.xpReward, 50);
    });

    test('should have On Fire badge with correct properties', () {
      final onFire = Badge.allBadges.firstWhere(
        (badge) => badge.id == 'streak_3',
      );

      expect(onFire.name, 'On Fire');
      expect(onFire.description, 'Reach a 3-day streak.');
      expect(onFire.assetPath, 'assets/images/badges/fire.png');
      expect(onFire.xpReward, 100);
    });

    test('should have Unstoppable badge with correct properties', () {
      final unstoppable = Badge.allBadges.firstWhere(
        (badge) => badge.id == 'streak_7',
      );

      expect(unstoppable.name, 'Unstoppable');
      expect(unstoppable.description, 'Reach a 7-day streak.');
      expect(unstoppable.assetPath, 'assets/images/badges/star.png');
      expect(unstoppable.xpReward, 250);
    });

    test('should have Early Bird badge with correct properties', () {
      final earlyBird = Badge.allBadges.firstWhere(
        (badge) => badge.id == 'early_bird',
      );

      expect(earlyBird.name, 'Early Bird');
      expect(earlyBird.description, 'Complete a habit before 8 AM.');
      expect(earlyBird.assetPath, 'assets/images/badges/sun.png');
      expect(earlyBird.xpReward, 150);
    });

    test('should have unique badge IDs', () {
      final ids = Badge.allBadges.map((badge) => badge.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, uniqueIds.length);
    });

    test('should have all badges with positive XP rewards', () {
      for (final badge in Badge.allBadges) {
        expect(badge.xpReward, greaterThan(0));
      }
    });

    test('should have all badges with non-empty names', () {
      for (final badge in Badge.allBadges) {
        expect(badge.name, isNotEmpty);
      }
    });

    test('should have all badges with non-empty descriptions', () {
      for (final badge in Badge.allBadges) {
        expect(badge.description, isNotEmpty);
      }
    });

    test('should have all badges with valid asset paths', () {
      for (final badge in Badge.allBadges) {
        expect(badge.assetPath, isNotEmpty);
        expect(badge.assetPath, startsWith('assets/'));
        expect(badge.assetPath, endsWith('.png'));
      }
    });

    test('should order badges by increasing difficulty/XP reward', () {
      // First Step (50) < On Fire (100) < Early Bird (150) < Unstoppable (250)
      expect(Badge.allBadges[0].xpReward, 50);
      expect(Badge.allBadges[1].xpReward, 100);
      expect(Badge.allBadges[2].xpReward, 250);
      expect(Badge.allBadges[3].xpReward, 150);
    });

    test('should be immutable (const constructor)', () {
      const badge1 = Badge(
        id: 'test',
        name: 'Test',
        description: 'Test',
        assetPath: 'test.png',
        xpReward: 50,
      );

      const badge2 = Badge(
        id: 'test',
        name: 'Test',
        description: 'Test',
        assetPath: 'test.png',
        xpReward: 50,
      );

      // Same values should be identical (const optimization)
      expect(identical(badge1, badge2), true);
    });

    test('should support finding badge by ID', () {
      final badge = Badge.allBadges.firstWhere(
        (b) => b.id == 'streak_7',
        orElse: () => throw Exception('Badge not found'),
      );

      expect(badge.name, 'Unstoppable');
    });

    test('should have streak-based badges', () {
      final streakBadges = Badge.allBadges
          .where((badge) => badge.id.startsWith('streak_'))
          .toList();

      expect(streakBadges.length, 2);
      expect(streakBadges.any((b) => b.id == 'streak_3'), true);
      expect(streakBadges.any((b) => b.id == 'streak_7'), true);
    });

    test('should have time-based badges', () {
      final timeBadges = Badge.allBadges
          .where((badge) => badge.description.contains('before'))
          .toList();

      expect(timeBadges.length, 1);
      expect(timeBadges.first.id, 'early_bird');
    });

    test('should have badges with high XP rewards', () {
      final highXpBadges = Badge.allBadges.where((b) => b.xpReward >= 200);
      expect(highXpBadges, isNotEmpty);
      expect(highXpBadges.first.name, 'Unstoppable');
    });

    test('should not have duplicate names', () {
      final names = Badge.allBadges.map((b) => b.name).toList();
      final uniqueNames = names.toSet();
      expect(names.length, uniqueNames.length);
    });
  });
}
