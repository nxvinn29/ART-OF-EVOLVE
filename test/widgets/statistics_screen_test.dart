import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/statistics/presentation/statistics_screen.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:art_of_evolve/src/features/habits/presentation/habits_controller.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';

class MockGamificationController extends StateNotifier<UserStats>
    implements GamificationController {
  MockGamificationController(super.initial);

  @override
  Future<void> addXp(int amount) async {}

  @override
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {}

  @override
  Future<void> resetStats() async {}
}

class MockHabitsController extends StateNotifier<AsyncValue<List<Habit>>>
    implements HabitsController {
  MockHabitsController(super.initial);

  @override
  Future<void> addHabit(
    String title, {
    String description = '',
    TimeOfDay? reminderTime,
  }) async {}

  @override
  Future<void> deleteHabit(String id) async {}

  @override
  Future<void> loadHabits() async {}

  @override
  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {}

  @override
  Future<void> updateHabit(Habit habit) async {}
}

void main() {
  testWidgets('StatisticsScreen renders correctly with data', (tester) async {
    // Set a large enough screen size to prevent overflow in tests
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final userStats = UserStats(
      level: 5,
      currentXp: 50,
      unlockedBadgeIds: ['first_step'],
    );

    final habits = [
      Habit(
        title: 'Workout',
        color: 0xFF000000,
        iconCodePoint: 58450,
        isDaily: true,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith(
            (ref) => MockGamificationController(userStats),
          ),
          habitsProvider.overrideWith(
            (ref) => MockHabitsController(AsyncData(habits)),
          ),
        ],
        child: const MaterialApp(home: StatisticsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('📊 Statistics & Insights'), findsOneWidget);

    // Verify XP Overview
    expect(find.text('🎯 Level 5'), findsOneWidget);
    expect(find.text('50 XP'), findsOneWidget);

    // Verify Habits Summary (1 total)
    expect(find.text('1'), findsAtLeastNWidgets(1));

    // Verify Achievements
    expect(find.text('First Step'), findsOneWidget);

    // Verify Streaks
    expect(find.text('🔥 Streaks'), findsOneWidget);
  });

  testWidgets('StatisticsScreen handles empty data', (tester) async {
    // Set a large enough screen size to prevent overflow in tests
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final userStats = UserStats(); // Default stats

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith(
            (ref) => MockGamificationController(userStats),
          ),
          habitsProvider.overrideWith(
            (ref) => MockHabitsController(const AsyncData([])),
          ),
        ],
        child: const MaterialApp(home: StatisticsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Default Level 1
    expect(find.text('🎯 Level 1'), findsOneWidget);

    // No badges
    expect(find.text('Complete habits to unlock badges!'), findsOneWidget);
  });
}
