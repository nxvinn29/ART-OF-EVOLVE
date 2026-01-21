import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockHiveBox extends Mock implements Box<UserSettings> {}

void main() {
  group('UserSettings', () {
    test('should have correct default values', () {
      final settings = UserSettings();

      expect(settings.is24HourTime, false);
      expect(settings.temperatureUnit, 'C');
      expect(settings.startOfWeek, 'Monday');
      expect(settings.dateFormat, 'dd/MM/yyyy');
    });

    test('should create instance with custom values', () {
      final settings = UserSettings(
        is24HourTime: true,
        temperatureUnit: 'F',
        startOfWeek: 'Sunday',
        dateFormat: 'yyyy-MM-dd',
      );

      expect(settings.is24HourTime, true);
      expect(settings.temperatureUnit, 'F');
      expect(settings.startOfWeek, 'Sunday');
      expect(settings.dateFormat, 'yyyy-MM-dd');
    });

    test('copyWith should return a new instance with updated values', () {
      final settings = UserSettings();
      final newSettings = settings.copyWith(
        is24HourTime: true,
        temperatureUnit: 'F',
      );

      expect(newSettings.is24HourTime, true);
      expect(newSettings.temperatureUnit, 'F');
      // Should retain original values for unspecified fields
      expect(newSettings.startOfWeek, settings.startOfWeek);
      expect(newSettings.dateFormat, settings.dateFormat);
    });

    test(
      'copyWith should return a new instance with same values if null passed',
      () {
        final settings = UserSettings(is24HourTime: true, temperatureUnit: 'F');
        final newSettings = settings.copyWith();

        expect(newSettings.is24HourTime, settings.is24HourTime);
        expect(newSettings.temperatureUnit, settings.temperatureUnit);
        expect(newSettings.startOfWeek, settings.startOfWeek);
        expect(newSettings.dateFormat, settings.dateFormat);
      },
    );
  });
}
