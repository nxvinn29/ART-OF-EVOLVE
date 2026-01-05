import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/core/theme/theme_controller.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'theme_controller_test.mocks.dart';

void main() {
  late MockBox mockBox;
  late ThemeModeNotifier themeNotifier;

  setUp(() {
    mockBox = MockBox();
    when(
      mockBox.get(any, defaultValue: anyNamed('defaultValue')),
    ).thenReturn('light');

    themeNotifier = ThemeModeNotifier(box: mockBox);
  });

  group('ThemeModeNotifier', () {
    test('initial state loads from box', () async {
      // Allow async init to complete
      await Future.delayed(Duration.zero);
      expect(themeNotifier.state, ThemeMode.light);
      verify(mockBox.get('theme_mode', defaultValue: 'system')).called(1);
    });

    test('setThemeMode updates state and saves to box', () async {
      await themeNotifier.setThemeMode(ThemeMode.dark);

      expect(themeNotifier.state, ThemeMode.dark);
      verify(mockBox.put('theme_mode', 'dark')).called(1);
    });

    test('toggleTheme switches from light to dark', () async {
      await themeNotifier.setThemeMode(ThemeMode.light);
      await themeNotifier.toggleTheme();

      expect(themeNotifier.state, ThemeMode.dark);
    });

    test('toggleTheme switches from dark to light', () async {
      await themeNotifier.setThemeMode(ThemeMode.dark);
      await themeNotifier.toggleTheme();

      expect(themeNotifier.state, ThemeMode.light);
    });

    test('handles error during load gracefully', () async {
      final errorBox = MockBox();
      when(
        errorBox.get(any, defaultValue: anyNamed('defaultValue')),
      ).thenThrow(Exception('Hive Error'));

      final notifier = ThemeModeNotifier(box: errorBox);
      await Future.delayed(Duration.zero);

      expect(notifier.state, ThemeMode.system);
    });

    test('handles error during save gracefully', () async {
      when(mockBox.put(any, any)).thenThrow(Exception('Hive Error'));

      await themeNotifier.setThemeMode(ThemeMode.dark);

      // State should update even if save fails, or depend on implementation
      // Current impl updates state first then saves
      expect(themeNotifier.state, ThemeMode.dark);
    });
  });
}
