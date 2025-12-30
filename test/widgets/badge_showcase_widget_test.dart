import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/widgets/badge_showcase_widget.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';

// Mock Controller
class MockGamificationController extends StateNotifier<UserStats>
    implements GamificationController {
  MockGamificationController(super.state);

  @override
  Future<void> addXp(int amount) async {}

  @override
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {}

  @override
  Future<void> resetStats() async {}
}

void main() {
  group('BadgeShowcaseWidget Tests', () {
    testWidgets('should hide when no badges are unlocked', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('Achievements'), findsNothing);
    });

    testWidgets('should display Achievements title when badges are unlocked', (
      tester,
    ) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('Achievements'), findsOneWidget);
    });

    testWidgets('should display unlocked badge name', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('First Step'), findsOneWidget);
    });

    testWidgets('should display multiple unlocked badges', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step', 'streak_3']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('First Step'), findsOneWidget);
      expect(find.text('On Fire'), findsOneWidget);
    });

    testWidgets('should use horizontal ListView', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('should display star icon for badges', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display correct number of badges', (tester) async {
      final testStats = UserStats(
        unlockedBadgeIds: ['first_step', 'streak_3', 'streak_7'],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(3));
    });

    testWidgets('should display all four badges when all unlocked', (
      tester,
    ) async {
      final testStats = UserStats(
        unlockedBadgeIds: ['first_step', 'streak_3', 'streak_7', 'early_bird'],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('First Step'), findsOneWidget);
      expect(find.text('On Fire'), findsOneWidget);
      expect(find.text('Unstoppable'), findsOneWidget);
      expect(find.text('Early Bird'), findsOneWidget);
    });

    testWidgets('should handle unknown badge gracefully', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['unknown_badge']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      expect(find.text('???'), findsOneWidget);
    });

    testWidgets('should have amber colored icons', (tester) async {
      final testStats = UserStats(unlockedBadgeIds: ['first_step']);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamificationControllerProvider.overrideWith(
              (ref) => MockGamificationController(testStats),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BadgeShowcaseWidget())),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.amber);
    });
  });
}
