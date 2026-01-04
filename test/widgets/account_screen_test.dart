import 'package:art_of_evolve/src/features/account/presentation/account_screen.dart';
import 'package:art_of_evolve/src/features/auth/presentation/auth_controller.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';
import 'package:art_of_evolve/src/features/onboarding/presentation/user_provider.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/settings/presentation/settings_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';

// Mock UserNotifier
class MockUserNotifier extends UserNotifier {
  @override
  UserProfile? build() {
    return UserProfile(
      wakeTime: DateTime.now(),
      name: 'Test User',
      mood: 'Happy',
      primaryGoal: 'Be Awesome',
    );
  }
}

void main() {
  setUp(() async {
    await setUpTestHive();
    // Register Adapters
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('AccountScreen renders correctly with user data', (tester) async {
    // Open box for SettingsController
    await Hive.openBox<UserSettings>('user_settings');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProvider.overrideWith(MockUserNotifier.new),
          // We can use the real SettingsController because we mocked Hive
          settingsProvider.overrideWith((ref) => SettingsController()),
          authProvider.overrideWith(
            (ref) => Stream.value(null),
          ), // Logged out state
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('SETTINGS'), findsOneWidget);

    // Verify User Name (from MockUserNotifier)
    expect(find.text('Test User'), findsOneWidget);

    // Verify Sections (Checking text is sufficient)
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Calendar display'), findsNothing); // Case sensitive check
  });
}
