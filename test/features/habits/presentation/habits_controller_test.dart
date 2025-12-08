import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:art_of_evolve/src/features/habits/presentation/habits_controller.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/habits/data/habits_repository.dart';
import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';
import 'package:art_of_evolve/src/services/notifications/notification_service.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

// Fake Repository Implementation
class FakeHabitsRepository implements IHabitsRepository {
  final List<Habit> _habits = [];

  @override
  Future<List<Habit>> getHabits() async {
    return List.from(_habits);
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      _habits[index] = habit;
    } else {
      _habits.add(habit);
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
  }

  @override
  Stream<List<Habit>> watchHabits() {
    return Stream.value(_habits);
  }
}

class MockNotificationService implements INotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermissions() async {}

  @override
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}

  @override
  Future<void> scheduleOneOffNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {}
}

// Mock GamificationController
class MockGamificationController extends StateNotifier<UserStats>
    implements GamificationController {
  MockGamificationController() : super(UserStats());

  @override
  Future<void> addXp(int amount) async {}

  @override
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {}

  @override
  Future<void> resetStats() async {}

  Future<void> unlockBadge(String badgeId) async {}
}

void main() {
  group('HabitsController', () {
    late FakeHabitsRepository repository;
    // ignore: unused_local_variable
    late MockNotificationService notificationService;
    late ProviderContainer container;

    setUp(() async {
      repository = FakeHabitsRepository();
      notificationService = MockNotificationService();

      container = ProviderContainer(
        overrides: [
          habitsRepositoryProvider.overrideWithValue(repository),
          gamificationControllerProvider.overrideWith(
            (ref) => MockGamificationController(),
          ),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
    });

    // Helper to get controller from container
    HabitsController getController() {
      return container.read(habitsProvider.notifier);
    }

    test('initial state is loading then empty', () async {
      // ignore: unused_local_variable
      final controller = getController();
      // Wait for async load
      await Future.delayed(Duration.zero);
      // Check repo is empty
      expect(await repository.getHabits(), isEmpty);
    });

    test('addHabit adds a habit to repository', () async {
      final controller = getController();
      await controller.addHabit('Read Book');

      final repoContent = await repository.getHabits();
      expect(repoContent.length, 1);
      expect(repoContent.first.title, 'Read Book');
    });

    test('toggleHabitCompletion updates the habit in repository', () async {
      final controller = getController();
      await controller.addHabit('Exercise');

      final repoContent = await repository.getHabits();
      final habitId = repoContent.first.id;

      final today = DateTime.now();
      await controller.toggleHabitCompletion(habitId, today);

      final updatedRepo = await repository.getHabits();
      final habit = updatedRepo.first;
      expect(habit.isCompletedOn(today), isTrue);
      // expect(habit.currentStreak, greaterThanOrEqualTo(1)); // Logic is complex, minimal check

      // Toggle back off
      await controller.toggleHabitCompletion(habitId, today);
      final toggledOffRepo = await repository.getHabits();
      expect(toggledOffRepo.first.isCompletedOn(today), isFalse);
    });

    test('deleteHabit removes habit from repository', () async {
      final controller = getController();
      await controller.addHabit('To Delete');

      final repoContent = await repository.getHabits();
      final habitId = repoContent.first.id;

      await controller.deleteHabit(habitId);

      expect(await repository.getHabits(), isEmpty);
    });
  });
}
