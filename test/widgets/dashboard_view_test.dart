import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/dashboard_view.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/dashboard_header.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/mood_tracker_widget.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/water_tracker_widget.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/mini_todo_list_widget.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/self_care_widget.dart';
import 'package:art_of_evolve/src/features/habits/presentation/habits_list.dart';
import 'package:art_of_evolve/src/services/storage/hive_service.dart';

// Domain imports for Adapters
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

void main() {
  group('DashboardView Widget Tests', () {
    setUp(() async {
      await setUpTestHive();

      // Register Adapters
      Hive.registerAdapter(HabitAdapter());
      Hive.registerAdapter(TodoAdapter());
      Hive.registerAdapter(GoalAdapter());
      Hive.registerAdapter(UserProfileAdapter());
      Hive.registerAdapter(JournalEntryAdapter());
      Hive.registerAdapter(UserSettingsAdapter());
      Hive.registerAdapter(UserStatsAdapter());

      // Open Boxes
      await Hive.openBox<Habit>(HiveService.habitsBoxName);
      await Hive.openBox<Todo>(HiveService.todosBoxName);
      await Hive.openBox<Goal>(HiveService.goalsBoxName);
      await Hive.openBox<UserProfile>(HiveService.userProfileBoxName);
      await Hive.openBox<JournalEntry>(HiveService.journalBoxName);
      await Hive.openBox<UserSettings>(HiveService.settingsBoxName);
      await Hive.openBox<UserStats>(HiveService.userStatsBoxName);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    testWidgets('renders all child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardView())),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DashboardHeader), findsOneWidget);
      expect(find.byType(MoodTrackerWidget), findsOneWidget);
      expect(find.byType(WaterTrackerWidget), findsOneWidget);
      expect(find.byType(MiniTodoListWidget), findsOneWidget);
      // self_care_widget might be SelfCareWidget
      expect(find.byType(SelfCareWidget), findsOneWidget);
      // HabitsList is used inside
      expect(find.byType(HabitsList), findsOneWidget);
    });
  });
}
