import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/widgets/gamification_overlay.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';
import 'package:confetti/confetti.dart';

// Mock Controller
class MockGamificationController extends StateNotifier<UserStats>
    implements GamificationController {
  MockGamificationController() : super(UserStats());

  void setStats(UserStats newStats) {
    state = newStats;
  }

  @override
  Future<void> addXp(int amount) async {}
  @override
  Future<void> checkUnlockConditions(bool isHabitCompletedToday) async {}
  @override
  Future<void> resetStats() async {}
}

void main() {
  testWidgets('GamificationOverlay shows confetti on level up', (
    WidgetTester tester,
  ) async {
    final mockController = MockGamificationController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith((ref) => mockController),
        ],
        child: const MaterialApp(
          home: Scaffold(body: GamificationOverlay(child: Text('Content'))),
        ),
      ),
    );

    expect(find.text('Content'), findsOneWidget);
    expect(find.byType(ConfettiWidget), findsOneWidget);

    // Trigger Level Up
    mockController.setStats(UserStats(level: 2));
    await tester.pump();

    // SnackBar should appear
    expect(find.text('Level Up! You are now level 2!'), findsOneWidget);
  });

  testWidgets('GamificationOverlay shows snackbar on badge unlock', (
    WidgetTester tester,
  ) async {
    final mockController = MockGamificationController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith((ref) => mockController),
        ],
        child: const MaterialApp(
          home: Scaffold(body: GamificationOverlay(child: Text('Content'))),
        ),
      ),
    );

    // Initial state
    expect(find.text('Content'), findsOneWidget);

    // Trigger Badge Unlock
    mockController.setStats(
      UserStats(
        unlockedBadgeIds: ['badge_1'], // New badge added
      ),
    );
    await tester.pump();

    // SnackBar should appear
    expect(find.text('Badge Unlocked: badge_1! Keep it up!'), findsOneWidget);
  });

  testWidgets('GamificationOverlay shows snackbar on XP gain', (
    WidgetTester tester,
  ) async {
    final mockController = MockGamificationController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith((ref) => mockController),
        ],
        child: const MaterialApp(
          home: Scaffold(body: GamificationOverlay(child: Text('Content'))),
        ),
      ),
    );

    // Initial state
    expect(find.text('Content'), findsOneWidget);

    // Trigger XP Gain
    mockController.setStats(
      UserStats(
        currentXp: 50, // Increase XP from default 0
      ),
    );
    await tester.pump();

    // SnackBar should appear
    expect(find.text('+50 XP! Great job!'), findsOneWidget);
  });
}
