import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:art_of_evolve/src/services/storage/hive_service.dart';

// Domain imports for Adapters
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return '';
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData(0);
  }
}

void main() {
  group('OnboardingScreen Widget Tests', () {
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

    testWidgets('renders initial page and can navigate', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: DefaultAssetBundle(
            bundle: MockAssetBundle(),
            child: const MaterialApp(home: OnboardingScreen()),
          ),
        ),
      );

      // Verify Initial Page
      expect(
        find.text('Let\'s start your journey.\nWhat should we call you?'),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);

      // Enter Name
      await tester.enterText(find.byType(TextField), 'Test User');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify Page 2 (Reasons)
      expect(
        find.text(
          'Why are you embarking on this journey to build healthy habits?',
        ),
        findsOneWidget,
      );
      expect(find.text('To improve my health'), findsOneWidget);

      // Select Option
      await tester.tap(find.text('To improve my health'));
      await tester.pumpAndSettle();

      // Verify Page 3 (Energy)
      expect(
        find.text('Throughout your day, how are your energy levels?'),
        findsOneWidget,
      );
    });
  });
}
