import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:art_of_evolve/src/services/notifications/push_notification_service.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseMessaging>(),
  MockSpec<NotificationSettings>(),
])
import 'push_notification_service_test.mocks.dart';

void main() {
  late MockFirebaseMessaging mockMessaging;
  late PushNotificationService service;

  setUp(() {
    mockMessaging = MockFirebaseMessaging();
    service = PushNotificationService(firebaseMessaging: mockMessaging);
  });

  group('PushNotificationService', () {
    test('getToken should return token from firebase messaging', () async {
      when(mockMessaging.getToken()).thenAnswer((_) async => 'test_token');

      final token = await service.getToken();

      expect(token, 'test_token');
      verify(mockMessaging.getToken()).called(1);
    });

    test('init should request permission', () async {
      final mockSettings = MockNotificationSettings();
      when(
        mockSettings.authorizationStatus,
      ).thenReturn(AuthorizationStatus.authorized);

      when(
        mockMessaging.requestPermission(alert: true, badge: true, sound: true),
      ).thenAnswer((_) async => mockSettings);

      await service.init();

      verify(
        mockMessaging.requestPermission(alert: true, badge: true, sound: true),
      ).called(1);
    });
  });
}
