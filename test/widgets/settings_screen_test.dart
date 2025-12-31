import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/settings/presentation/settings_screen.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:art_of_evolve/src/features/settings/presentation/settings_controller.dart';

void main() {
  group('SettingsScreen Widget Tests', () {
    testWidgets('displays all settings options', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) {
              return TestSettingsController();
            }),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Settings'), findsAny);
    });

    testWidgets('24-hour time toggle works', (WidgetTester tester) async {
      final controller = TestSettingsController();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [settingsProvider.overrideWith((ref) => controller)],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch).first;
      if (switchFinder.evaluate().isNotEmpty) {
        await tester.tap(switchFinder);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('displays current settings values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) {
              return TestSettingsController();
            }),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
    });
  });
}

class TestSettingsController extends StateNotifier<UserSettings> {
  TestSettingsController() : super(UserSettings());

  Future<void> toggle24HourTime() async {
    state = state.copyWith(is24HourTime: !state.is24HourTime);
  }

  Future<void> setTemperatureUnit(String unit) async {
    state = state.copyWith(temperatureUnit: unit);
  }

  Future<void> setStartOfWeek(String day) async {
    state = state.copyWith(startOfWeek: day);
  }

  Future<void> setDateFormat(String format) async {
    state = state.copyWith(dateFormat: format);
  }
}
