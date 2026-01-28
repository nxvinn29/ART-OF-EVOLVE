import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/core/theme/theme_controller.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'theme_controller_test.mocks.dart';

void main() {
  late MockBox mockBox;
  late ThemeModeNotifier notifier;

  setUp(() {
    mockBox = MockBox();
    when(
      mockBox.get(any, defaultValue: anyNamed('defaultValue')),
    ).thenReturn('system');
    notifier = ThemeModeNotifier(box: mockBox);
    await Future.delayed(Duration.zero);
  });

  group('ThemeModeNotifier', () {
    test('initial state should be system', () {
      expect(notifier.state, ThemeMode.system);
    });

    test('setThemeMode should update state and save to box', () async {
      await notifier.setThemeMode(ThemeMode.dark);

      expect(notifier.state, ThemeMode.dark);
      verify(mockBox.put('theme_mode', 'dark')).called(1);
    });

    test('toggleTheme should switch between light and dark', () async {
      // Set to light first
      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.state, ThemeMode.light);

      // Toggle to dark
      await notifier.toggleTheme();
      expect(notifier.state, ThemeMode.dark);
      verify(mockBox.put('theme_mode', 'dark')).called(1);

      // Toggle back to light
      await notifier.toggleTheme();
      expect(notifier.state, ThemeMode.light);
      verify(mockBox.put('theme_mode', 'light')).called(1);
    });
  });
}
