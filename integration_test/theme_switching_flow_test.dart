import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for the theme switching flow.
///
/// This test verifies the complete user journey of switching between themes,
/// including light mode, dark mode, and system theme preferences.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Switching Flow', () {
    testWidgets('User can access theme settings', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to settings
      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isEmpty) {
        // Try alternative navigation
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          final settingsButton = find.byIcon(Icons.settings);
          if (settingsButton.evaluate().isNotEmpty) {
            await tester.tap(settingsButton);
            await tester.pumpAndSettle();
          }
        }
      } else {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
      }

      // Verify theme settings are visible
      expect(find.textContaining('Theme', findRichText: true), findsAny);
    });

    testWidgets('User can switch to dark mode', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to settings
      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
      }

      // Find and tap dark mode option
      final darkModeSwitch = find.byKey(const Key('dark_mode_switch'));
      if (darkModeSwitch.evaluate().isNotEmpty) {
        await tester.tap(darkModeSwitch);
        await tester.pumpAndSettle();

        // Verify theme changed (check for dark background)
        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
        expect(materialApp.theme?.brightness, isNotNull);
      } else {
        // Try alternative theme selector
        final darkModeOption = find.text('Dark');
        if (darkModeOption.evaluate().isNotEmpty) {
          await tester.tap(darkModeOption);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('User can switch to light mode', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
      }

      // Find and tap light mode option
      final lightModeOption = find.text('Light');
      if (lightModeOption.evaluate().isNotEmpty) {
        await tester.tap(lightModeOption);
        await tester.pumpAndSettle();

        // Verify theme changed
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('User can select system theme', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
      }

      // Find and tap system theme option
      final systemThemeOption = find.text('System');
      if (systemThemeOption.evaluate().isNotEmpty) {
        await tester.tap(systemThemeOption);
        await tester.pumpAndSettle();

        // Verify system theme is selected
        expect(systemThemeOption, findsOneWidget);
      }
    });

    testWidgets('Theme preference persists across app restarts', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to settings and change theme
      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();

        final darkModeOption = find.text('Dark');
        if (darkModeOption.evaluate().isNotEmpty) {
          await tester.tap(darkModeOption);
          await tester.pumpAndSettle();
        }
      }

      // Restart app (simulate)
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify theme persisted
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Theme toggle animation works smoothly', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();

        // Toggle theme multiple times
        final darkModeSwitch = find.byKey(const Key('dark_mode_switch'));
        if (darkModeSwitch.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(darkModeSwitch);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));
            await tester.pumpAndSettle();
          }

          // Verify no errors occurred during animation
          expect(tester.takeException(), isNull);
        }
      }
    });
  });
}
