import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../domain/user_settings.dart';

const String settingsBoxName = 'user_settings';

final settingsProvider =
    StateNotifierProvider<SettingsController, UserSettings>((ref) {
      return SettingsController();
    });

class SettingsController extends StateNotifier<UserSettings> {
  SettingsController() : super(UserSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox<UserSettings>(settingsBoxName);
    if (box.isNotEmpty) {
      state = box.getAt(0)!;
    } else {
      // Initialize defaults if empty
      final defaultSettings = UserSettings();
      await box.add(defaultSettings);
      state = defaultSettings;
    }
  }

  Future<void> _saveSettings(UserSettings settings) async {
    final box = await Hive.openBox<UserSettings>(settingsBoxName);
    await box.putAt(0, settings);
    state = settings;
  }

  /// Toggles the 24-hour time format setting.
  Future<void> toggle24HourTime() async {
    final newSettings = state.copyWith(is24HourTime: !state.is24HourTime);
    await _saveSettings(newSettings);
  }

  Future<void> setTemperatureUnit(String unit) async {
    final newSettings = state.copyWith(temperatureUnit: unit);
    await _saveSettings(newSettings);
  }

  Future<void> setStartOfWeek(String day) async {
    final newSettings = state.copyWith(startOfWeek: day);
    await _saveSettings(newSettings);
  }

  Future<void> setDateFormat(String format) async {
    final newSettings = state.copyWith(dateFormat: format);
    await _saveSettings(newSettings);
  }
}
