import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Interface for notification services.
///
/// Defines contract for scheduling, canceling, and managing local notifications.
abstract class INotificationService {
  Future<void> init();
  Future<void> requestPermissions();
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  });
  Future<void> scheduleOneOffNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  });
  Future<void> cancelNotification(int id);
  Future<void> cancelReminder(int id);
}

class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _notifications;

  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal(
    FlutterLocalNotificationsPlugin(),
  );

  factory NotificationService() {
    return _instance;
  }

  // Visible for testing
  NotificationService.test(this._notifications);

  NotificationService._internal(this._notifications);

  // Static helper for main.dart if we want to keep static init style,
  // but main.dart was updated to use static init.
  // We should support both or revert main.dart to use instance.
  // To match previous main.dart usage validation, let's just make sure init is available as instance method.

  static Future<void> initStatic() async {
    await _instance.init();
  }

  @override
  Future<void> init() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  @override
  Future<void> requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Schedules a reminder at a specific [scheduledDate].
  @override
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'journal_reminders',
          'Journal Reminders',
          channelDescription: 'Reminders for journal entries',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedules a daily notification at a specific [time].
  @override
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_habits',
          'Daily Habits',
          channelDescription: 'Daily reminders for habits',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelNotification(int id) => cancelReminder(id);

  @override
  Future<void> scheduleOneOffNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(delay),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_timer',
          'Focus Timer',
          channelDescription: 'Timer completion notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }
}
