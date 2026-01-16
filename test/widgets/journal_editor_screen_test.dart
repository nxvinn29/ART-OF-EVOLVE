import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_editor_screen.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/voice_recorder_widget.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/format_toolbar.dart';
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
  group('JournalEditorScreen Widget Tests', () {
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

    testWidgets('renders editor components', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalEditorScreen())),
      );

      // Verify TextFields (Title and Content)
      expect(find.byType(TextField), findsAtLeastNWidgets(1));

      // Verify Toolbar
      expect(find.byType(FormatToolbar), findsOneWidget);

      // Verify Voice Recorder
      expect(find.byType(VoiceRecorderWidget), findsOneWidget);
    });

    testWidgets('can type in title field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalEditorScreen())),
      );

      await tester.enterText(find.byType(TextField).first, 'My Journal Entry');
      expect(find.text('My Journal Entry'), findsOneWidget);
    });
  });
}
