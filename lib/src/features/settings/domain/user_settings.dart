import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 5)
/// Represents global user settings and preferences.
///
/// This model is persisted using Hive and manages application-wide configuration
/// such as time format, temperature units, and date preferences.
class UserSettings extends HiveObject {
  /// Whether to use 24-hour format for time display.
  ///
  /// specific UI components should check this preference to decide
  /// between '13:00' (true) or '1:00 PM' (false).
  @HiveField(0)
  final bool is24HourTime;

  /// The preferred unit for temperature display.
  ///
  /// - 'C': Celsius
  /// - 'F': Fahrenheit
  @HiveField(1)
  final String temperatureUnit;

  /// The day of the week the user considers as the start of the week.
  ///
  /// Typically 'Monday' or 'Sunday'. Used for calendar and statistics calculations.
  @HiveField(2)
  final String startOfWeek;

  /// The preferred date format pattern.
  ///
  /// Examples: 'dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd'.
  @HiveField(3)
  final String dateFormat;

  /// Creates a new [UserSettings] instance with optional parameters.
  ///
  /// Defaults:
  /// - [is24HourTime]: false
  /// - [temperatureUnit]: 'C'
  /// - [startOfWeek]: 'Monday'
  /// - [dateFormat]: 'dd/MM/yyyy'
  UserSettings({
    this.is24HourTime = false,
    this.temperatureUnit = 'C',
    this.startOfWeek = 'Monday',
    this.dateFormat = 'dd/MM/yyyy',
  });

  /// Creates a copy of this [UserSettings] with the given fields replaced.
  UserSettings copyWith({
    bool? is24HourTime,
    String? temperatureUnit,
    String? startOfWeek,
    String? dateFormat,
  }) {
    return UserSettings(
      is24HourTime: is24HourTime ?? this.is24HourTime,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      startOfWeek: startOfWeek ?? this.startOfWeek,
      dateFormat: dateFormat ?? this.dateFormat,
    );
  }
}
