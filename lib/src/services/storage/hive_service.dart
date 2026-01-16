import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/todos/domain/todo.dart';
import '../../features/goals/domain/goal.dart';
import '../../features/onboarding/domain/user_profile.dart';
import '../../features/settings/domain/user_settings.dart';
import '../../features/self_care/domain/journal_entry.dart';
import '../../features/gamification/domain/user_stats.dart';

/// Service to handle local storage using Hive.
///
/// This service is responsible for initializing Hive, registering adapters,
/// and opening boxes for storing various data models.
class HiveService {
  static const String habitsBoxName = 'habits';
  static const String todosBoxName = 'todos';
  static const String goalsBoxName = 'goals';
  static const String userProfileBoxName = 'user_profile';
  static const String journalBoxName = 'journal';
  static const String settingsBoxName = 'user_settings';
  static const String userStatsBoxName = 'user_stats';

  /// Initializes Hive and registers adapters.
  ///
  /// This method is called at the start of the application.
  /// Throws an exception if initialization fails.
  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register Adapters
      _registerAdapters();

      // Open Boxes
      await _openBoxes();
    } catch (e) {
      debugPrint('HiveService: Failed to initialize Hive: $e');
      rethrow;
    }
  }

  /// Registers all necessary Hive adapters.
  ///
  /// Ensures that adapters are not registered multiple times.
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TodoAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GoalAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(JournalEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(UserStatsAdapter());
    }
  }

  /// Opens all Hive boxes used in the application.
  static Future<void> _openBoxes() async {
    await Hive.openBox<Habit>(habitsBoxName);
    await Hive.openBox<Todo>(todosBoxName);
    await Hive.openBox<Goal>(goalsBoxName);
    await Hive.openBox<UserProfile>(userProfileBoxName);
    await Hive.openBox<JournalEntry>(journalBoxName);
    await Hive.openBox<UserSettings>(settingsBoxName);
    await Hive.openBox<UserStats>(userStatsBoxName);
  }

  /// Accessor for the habits box.
  static Box<Habit> get habitsBox => Hive.box<Habit>(habitsBoxName);

  /// Accessor for the todos box.
  static Box<Todo> get todosBox => Hive.box<Todo>(todosBoxName);

  /// Accessor for the goals box.
  static Box<Goal> get goalsBox => Hive.box<Goal>(goalsBoxName);

  /// Accessor for the user profile box.
  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(userProfileBoxName);

  /// Accessor for the journal box.
  static Box<JournalEntry> get journalBox =>
      Hive.box<JournalEntry>(journalBoxName);

  /// Accessor for the user settings box.
  static Box<UserSettings> get settingsBox =>
      Hive.box<UserSettings>(settingsBoxName);

  /// Accessor for the user stats box.
  static Box<UserStats> get userStatsBox =>
      Hive.box<UserStats>(userStatsBoxName);
}
