import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:art_of_evolve/src/features/settings/presentation/settings_controller.dart';
import 'package:art_of_evolve/src/features/settings/domain/user_settings.dart';

void main() {
  group('SettingsController', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('initial state loads default settings', () async {
      final controller = SettingsController();

      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.state, isA<UserSettings>());
      controller.dispose();
    });

    test('toggle24HourTime changes time format setting', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      final initialValue = controller.state.is24HourTime;

      await controller.toggle24HourTime();

      expect(controller.state.is24HourTime, !initialValue);

      // Toggle again
      await controller.toggle24HourTime();
      expect(controller.state.is24HourTime, initialValue);

      controller.dispose();
    });

    test('setTemperatureUnit updates temperature unit', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setTemperatureUnit('Fahrenheit');
      expect(controller.state.temperatureUnit, 'Fahrenheit');

      await controller.setTemperatureUnit('Celsius');
      expect(controller.state.temperatureUnit, 'Celsius');

      controller.dispose();
    });

    test('setStartOfWeek updates start of week setting', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setStartOfWeek('Monday');
      expect(controller.state.startOfWeek, 'Monday');

      await controller.setStartOfWeek('Sunday');
      expect(controller.state.startOfWeek, 'Sunday');

      controller.dispose();
    });

    test('setDateFormat updates date format setting', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setDateFormat('MM/DD/YYYY');
      expect(controller.state.dateFormat, 'MM/DD/YYYY');

      await controller.setDateFormat('DD/MM/YYYY');
      expect(controller.state.dateFormat, 'DD/MM/YYYY');

      controller.dispose();
    });

    test('settings persist across controller instances', () async {
      // Create first controller and change settings
      final controller1 = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller1.setTemperatureUnit('Fahrenheit');
      await controller1.setStartOfWeek('Monday');
      controller1.dispose();

      // Create second controller and verify settings persisted
      final controller2 = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller2.state.temperatureUnit, 'Fahrenheit');
      expect(controller2.state.startOfWeek, 'Monday');

      controller2.dispose();
    });

    test('multiple setting changes are applied correctly', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.toggle24HourTime();
      await controller.setTemperatureUnit('Kelvin');
      await controller.setStartOfWeek('Wednesday');
      await controller.setDateFormat('YYYY-MM-DD');

      expect(controller.state.temperatureUnit, 'Kelvin');
      expect(controller.state.startOfWeek, 'Wednesday');
      expect(controller.state.dateFormat, 'YYYY-MM-DD');

      controller.dispose();
    });

    test('copyWith preserves other settings when updating one', () async {
      final controller = SettingsController();
      await Future.delayed(const Duration(milliseconds: 100));

      // Set initial values
      await controller.setTemperatureUnit('Celsius');
      await controller.setStartOfWeek('Sunday');
      final initialTimeFormat = controller.state.is24HourTime;

      // Change only date format
      await controller.setDateFormat('DD-MM-YYYY');

      // Verify other settings remain unchanged
      expect(controller.state.temperatureUnit, 'Celsius');
      expect(controller.state.startOfWeek, 'Sunday');
      expect(controller.state.is24HourTime, initialTimeFormat);
      expect(controller.state.dateFormat, 'DD-MM-YYYY');

      controller.dispose();
    });
  });
}
