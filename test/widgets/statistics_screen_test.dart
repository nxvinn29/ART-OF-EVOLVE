import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/habits/presentation/habits_controller.dart';
import 'package:art_of_evolve/src/features/statistics/presentation/statistics_screen.dart';
import 'package:art_of_evolve/src/services/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/mockito.dart';

// Mock Interfaces
class MockHabitsRepository extends Mock implements IHabitsRepository {}

class MockNotificationService extends Mock implements INotificationService {}

// Mock HabitsController
class MockHabitsController extends HabitsController {
  MockHabitsController(super.repository, super.notificationService, super.ref);
}

class MockGamificationController extends GamificationController {
  final UserStats initialStats;
  MockGamificationController(this.initialStats) : super() {
    state = initialStats;
  }
}

void main() {
  late MockHabitsRepository mockHabitsRepository;
  late MockNotificationService mockNotificationService;

  setUp(() async {
    await setUpTestHive();
    // Register Adapters
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(UserStatsAdapter());
    }
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }

    mockHabitsRepository = MockHabitsRepository();
    mockNotificationService = MockNotificationService();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('StatisticsScreen renders correctly with data', (tester) async {
    // Open Boxes
    await Hive.openBox<UserStats>('user_stats');
    await Hive.openBox<Habit>('habits');

    // Prepare Data
    final testHabit = Habit(
      id: '1',
      title: 'Meditation',
      color: 0xFF000000,
      iconCodePoint: 123,
      completedDates: [DateTime.now()],
    );

    final testStats = UserStats(
      level: 5,
      currentXp: 250,
      totalHabitsCompleted: 10,
      currentStreak: 3,
      unlockedBadgeIds: ['first_step'],
    );

    when(mockHabitsRepository.getHabits()).thenAnswer((_) async => [testHabit]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith(
            (ref) => MockGamificationController(testStats),
          ),
          habitsProvider.overrideWith((ref) {
            return MockHabitsController(
              mockHabitsRepository,
              mockNotificationService,
              ref,
            );
          }),
        ],
        child: const MaterialApp(home: StatisticsScreen()),
      ),
    );

    // Pump to allow Futures to complete
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('📊 Statistics & Insights'), findsOneWidget);

    // Verify Level and XP
    expect(find.text('🎯 Level 5'), findsOneWidget);
    expect(find.text('250 XP'), findsOneWidget);

    // Verify Habits Summary
    expect(find.text('✅ Habits Summary'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    // Values might depend on logic, e.g. 1 habit
    expect(find.text('1'), findsAtLeastNWidgets(1));

    // Verify Achievements
    expect(find.text('🏆 Achievements'), findsOneWidget);
    expect(find.text('First Step'), findsOneWidget);

    // Verify Streaks
    expect(find.text('🔥 Streaks'), findsOneWidget);
    expect(find.text('Longest'), findsOneWidget);
  });
}
