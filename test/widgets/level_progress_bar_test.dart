import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/widgets/level_progress_bar.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/features/gamification/domain/user_stats.dart';

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
  testWidgets('LevelProgressBar displays correct level and XP details', (
    WidgetTester tester,
  ) async {
    // Arrange
    final testStats = UserStats(
      level: 5,
      currentXp: 250,
      totalHabitsCompleted: 10,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gamificationControllerProvider.overrideWith(
            (ref) => MockGamificationController(testStats),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: LevelProgressBar(),
            ),
          ),
        ),
      ),
    );

    // Act & Assert
    // Check Level text
    expect(find.text('Level 5'), findsOneWidget);

    // Check XP text: 5 * 100 = 500 XP required.
    // Display: "250 / 500 XP"
    expect(find.text('250 / 500 XP'), findsOneWidget);

    // Check Progress Indicator
    final progressFinder = find.byType(LinearProgressIndicator);
    expect(progressFinder, findsOneWidget);

    final indicator = tester.widget<LinearProgressIndicator>(progressFinder);
    expect(indicator.value, 0.5); // 250 / 500 = 0.5
  });
}
