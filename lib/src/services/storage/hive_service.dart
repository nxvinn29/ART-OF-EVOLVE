import 'package:hive_flutter/hive_flutter.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/todos/domain/todo.dart';
import '../../features/goals/domain/goal.dart';
import '../../features/onboarding/domain/user_profile.dart';
import '../../features/settings/domain/user_settings.dart';
import '../../features/self_care/domain/journal_entry.dart';
import '../../features/gamification/domain/user_stats.dart';

class HiveService {
  static const String habitsBoxName = 'habits';
  static const String todosBoxName = 'todos';
  static const String goalsBoxName = 'goals';
  static const String userProfileBoxName = 'user_profile';
  static const String journalBoxName = 'journal';
  static const String settingsBoxName = 'user_settings';
  static const String userStatsBoxName = 'user_stats';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(UserStatsAdapter());

    // Open Boxes
    await Hive.openBox<Habit>(habitsBoxName);
    await Hive.openBox<Todo>(todosBoxName);
    await Hive.openBox<Goal>(goalsBoxName);
    await Hive.openBox<UserProfile>(userProfileBoxName);
    await Hive.openBox<JournalEntry>(journalBoxName);
    await Hive.openBox<UserSettings>(settingsBoxName);
    await Hive.openBox<UserStats>(userStatsBoxName);
  }

  static Box<Habit> get habitsBox => Hive.box<Habit>(habitsBoxName);
  static Box<Todo> get todosBox => Hive.box<Todo>(todosBoxName);
  static Box<Goal> get goalsBox => Hive.box<Goal>(goalsBoxName);
  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(userProfileBoxName);
  static Box<JournalEntry> get journalBox =>
      Hive.box<JournalEntry>(journalBoxName);
  static Box<UserSettings> get settingsBox =>
      Hive.box<UserSettings>(settingsBoxName);
  static Box<UserStats> get userStatsBox =>
      Hive.box<UserStats>(userStatsBoxName);
}
