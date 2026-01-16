import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/services/storage/hive_service.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

void main() {
  group('HiveService Tests', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('should initialize Hive and register adapters', () async {
      // Act
      await HiveService.init();

      // Assert
      expect(Hive.isAdapterRegistered(0), isTrue); // HabitAdapter
      expect(Hive.isAdapterRegistered(1), isTrue); // TodoAdapter
      expect(Hive.isAdapterRegistered(2), isTrue); // GoalAdapter
      expect(Hive.isAdapterRegistered(3), isTrue); // UserProfileAdapter
      expect(Hive.isAdapterRegistered(4), isTrue); // JournalEntryAdapter
      expect(Hive.isAdapterRegistered(5), isTrue); // UserSettingsAdapter
      expect(Hive.isAdapterRegistered(6), isTrue); // UserStatsAdapter
    });

    test('should open all boxes', () async {
      // Act
      await HiveService.init();

      // Assert
      expect(Hive.isBoxOpen(HiveService.habitsBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.todosBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.goalsBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.userProfileBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.journalBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.settingsBoxName), isTrue);
      expect(Hive.isBoxOpen(HiveService.userStatsBoxName), isTrue);
    });

    test('should access boxes via getters', () async {
      // Arrange
      await HiveService.init();

      // Act & Assert
      expect(HiveService.habitsBox, isA<Box<Habit>>());
      expect(HiveService.todosBox, isA<Box<Todo>>());
      expect(HiveService.goalsBox, isA<Box<Goal>>());
      expect(HiveService.userProfileBox, isA<Box<UserProfile>>());
      expect(HiveService.journalBox, isA<Box<JournalEntry>>());
      expect(HiveService.settingsBox, isA<Box<UserSettings>>());
      expect(HiveService.userStatsBox, isA<Box<UserStats>>());
    });
  });
}
