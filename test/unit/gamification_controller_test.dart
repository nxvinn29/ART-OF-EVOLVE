import 'dart:io';

import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/services/storage/hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    // Register Adapter
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(UserStatsAdapter());
    }

    // Open Box
    await Hive.openBox<UserStats>(HiveService.userStatsBoxName);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  group('GamificationController', () {
    test('initializes with default stats', () {
      final controller = GamificationController();
      expect(controller.state.level, 1);
      expect(controller.state.currentXp, 0);
    });

    test('addXp increases XP and handles level up', () async {
      final controller = GamificationController();

      // Level 1: 100 XP to next level
      await controller.addXp(50);
      expect(controller.state.currentXp, 50);
      expect(controller.state.level, 1);

      // Add 60 => 110 XP total. Should Level up to 2.
      // 110 - 100 (req) = 10 XP remaining.
      await controller.addXp(60);
      expect(controller.state.level, 2);
      expect(controller.state.currentXp, 10);
    });

    test('checkUnlockConditions unlocks First Step badge', () async {
      final controller = GamificationController();

      await controller.checkUnlockConditions(true);

      expect(controller.state.totalHabitsCompleted, 1);
      expect(controller.state.unlockedBadgeIds, contains('first_step'));
      // XP should increase by 50 for badge
      expect(controller.state.currentXp, 50);
    });

    test('resetStats clears progress', () async {
      final controller = GamificationController();
      await controller.addXp(150); // Level 2, 50 XP

      await controller.resetStats();

      expect(controller.state.level, 1);
      expect(controller.state.currentXp, 0);
      expect(controller.state.totalHabitsCompleted, 0);
    });
  });
}
