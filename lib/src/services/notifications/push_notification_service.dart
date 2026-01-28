import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `Firebase.initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

/// Service for handling Push Notifications using Firebase Messaging.
///
/// Handles:
/// - Requesting permissions.
/// - Background message handling.
/// - Foreground message listening.
/// - Token retrieval.
class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationService({FirebaseMessaging? firebaseMessaging})
    : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  /// Initializes the service.
  ///
  /// Requests notification permissions (alert, badge, sound).
  /// Sets up background and foreground message listeners.
  ///
  /// Logs permission status and messages in debug mode.
  Future<void> init() async {
    // Request permission for iOS
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    // Set background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
        }
        // Could show a local notification here using NotificationService
      }
    });
  }

  /// Retrieves the Firebase Cloud Messaging (FCM) token for this device.
  ///
  /// Takes no arguments.
  /// Returns a [Future] that resolves to the token string, or null if retrieval fails.
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
