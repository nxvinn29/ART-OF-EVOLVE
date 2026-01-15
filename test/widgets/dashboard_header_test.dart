import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/dashboard_header.dart';
import 'package:art_of_evolve/src/features/onboarding/presentation/user_provider.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/widgets/level_progress_bar.dart';

// Mock UserNotifier
class MockUserNotifier extends UserNotifier {
  @override
  UserProfile? build() {
    return UserProfile(name: 'Test User', wakeTime: DateTime.now());
  }
}

class MockUserNotifierEmptyName extends UserNotifier {
  @override
  UserProfile? build() {
    return UserProfile(name: '', wakeTime: DateTime.now());
  }
}

class FakeGamificationController extends StateNotifier<UserStats>
    implements GamificationController {
  FakeGamificationController() : super(UserStats(level: 5, currentXp: 250));

  @override
  Future<void> addXp(int amount) async {}
  @override
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {}
  @override
  Future<void> resetStats() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DashboardHeader Widget Tests', () {
    testWidgets('renders correctly with default values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith(MockUserNotifier.new),
            gamificationControllerProvider.overrideWith(
              (ref) => FakeGamificationController(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: DashboardHeader())),
        ),
      );

      // Verify that the widget renders
      expect(find.byType(DashboardHeader), findsOneWidget);

      // Verify profile avatar
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('T'), findsOneWidget); // 'Test User' -> 'T'

      // Verify name
      expect(find.text('Test User'), findsOneWidget);

      // Verify daily intention
      expect(find.text('Release what you cannot control.'), findsOneWidget);

      // Verify LevelProgressBar
      expect(find.byType(LevelProgressBar), findsOneWidget);

      // Verify Level stats from fake controller
      expect(find.text('Level 5'), findsOneWidget);
    });

    testWidgets('renders greeting text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith(MockUserNotifier.new),
            gamificationControllerProvider.overrideWith(
              (ref) => FakeGamificationController(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: DashboardHeader())),
        ),
      );

      // Verify greeting text based on time
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text) {
            final data = widget.data;
            return data != null &&
                (data.contains('Good Morning') ||
                    data.contains('Good Afternoon') ||
                    data.contains('Good Evening'));
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('shows "Friend" when name is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith(MockUserNotifierEmptyName.new),
            gamificationControllerProvider.overrideWith(
              (ref) => FakeGamificationController(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: DashboardHeader())),
        ),
      );

      // Verify name defaults to Friend
      expect(find.text('Friend'), findsOneWidget);
      expect(find.text('F'), findsOneWidget); // Avatar initial
    });
  });
}
