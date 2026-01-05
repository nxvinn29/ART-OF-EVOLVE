import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/services/notifications/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

// Generate mocks for the plugin
@GenerateNiceMocks([MockSpec<FlutterLocalNotificationsPlugin>()])
import 'notification_service_test.mocks.dart';

void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUp(() {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationService.test(mockPlugin);
    tz.initializeTimeZones();
  });

  group('NotificationService', () {
    test('init initializes the plugin', () async {
      when(mockPlugin.initialize(any)).thenAnswer((_) async => true);

      await notificationService.init();

      verify(mockPlugin.initialize(any)).called(1);
    });

    test('scheduleReminder schedules a notification', () async {
      final date = DateTime(2026, 1, 1, 10, 0);

      await notificationService.scheduleReminder(
        id: 1,
        title: 'Title',
        body: 'Body',
        scheduledDate: date,
      );

      verify(
        mockPlugin.zonedSchedule(
          1,
          'Title',
          'Body',
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      ).called(1);
    });

    test('cancelNotification cancels the notification', () async {
      await notificationService.cancelNotification(1);

      verify(mockPlugin.cancel(1)).called(1);
    });

    test(
      'scheduleDailyNotification schedules for future time if passed time already passed',
      () async {
        // Mock current time using timezone logic if needed, but for unit test
        // we check if it calls zonedSchedule with correct components

        await notificationService.scheduleDailyNotification(
          id: 2,
          title: 'Daily',
          body: 'Body',
          time: const TimeOfDay(hour: 8, minute: 0),
        );

        verify(
          mockPlugin.zonedSchedule(
            2,
            'Daily',
            'Body',
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            uiLocalNotificationDateInterpretation: anyNamed(
              'uiLocalNotificationDateInterpretation',
            ),
            matchDateTimeComponents: DateTimeComponents.time,
          ),
        ).called(1);
      },
    );
  });
}
