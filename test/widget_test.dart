import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/app.dart';
import 'package:art_of_evolve/src/services/storage/hive_service.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive in a temporary directory
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    // Register Adapters
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HabitAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TodoAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(GoalAdapter());
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(JournalEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(UserStatsAdapter());

    // Open Boxes
    await Hive.openBox<Habit>(HiveService.habitsBoxName);
    await Hive.openBox<Todo>(HiveService.todosBoxName);
    await Hive.openBox<Goal>(HiveService.goalsBoxName);
    await Hive.openBox<UserProfile>(HiveService.userProfileBoxName);
    await Hive.openBox<JournalEntry>(HiveService.journalBoxName);
    await Hive.openBox<UserSettings>(HiveService.settingsBoxName);
    await Hive.openBox<UserStats>(HiveService.userStatsBoxName);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ArtOfEvolveApp()));

    // Verify that the app builds.
    expect(find.text('Art of Evolve'), findsNothing);
  });
}
