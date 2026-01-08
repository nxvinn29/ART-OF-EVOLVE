import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/focus_timer_screen.dart';
import 'package:art_of_evolve/src/services/notifications/notification_service.dart';

// Mock NotificationService
class MockNotificationService extends Mock implements INotificationService {
  @override
  Future<void> scheduleOneOffNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}
}

void main() {
  testWidgets('FocusTimerScreen renders and responds to mode changes', (
    WidgetTester tester,
  ) async {
    final mockNotificationService = MockNotificationService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationServiceProvider.overrideWithValue(
            mockNotificationService,
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: FocusTimerScreen())),
      ),
    );

    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('Short Break'), findsOneWidget);
    expect(find.text('Long Break'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget); // Default Focus time

    // Tap Short Break
    await tester.tap(find.text('Short Break'));
    await tester.pumpAndSettle();

    expect(find.text('05:00'), findsOneWidget);
    expect(find.text('PAUSED'), findsOneWidget);

    // Start Timer
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    expect(find.text('RUNNING'), findsOneWidget);
    verify(
      mockNotificationService.scheduleOneOffNotification(
        id: 999,
        title: 'Short Break Session Complete',
        body: 'Great job! Time to take a break or start a new session.',
        delay: const Duration(seconds: 300),
      ),
    ).called(1);
  });
}
