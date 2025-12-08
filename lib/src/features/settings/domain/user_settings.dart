import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 5)
class UserSettings extends HiveObject {
  @HiveField(0)
  final bool is24HourTime;

  @HiveField(1)
  final String temperatureUnit; // 'C' or 'F'

  @HiveField(2)
  final String startOfWeek; // 'Monday' or 'Sunday'

  @HiveField(3)
  final String dateFormat; // e.g., 'dd/MM/yyyy'

  UserSettings({
    this.is24HourTime = false,
    this.temperatureUnit = 'C',
    this.startOfWeek = 'Monday',
    this.dateFormat = 'dd/MM/yyyy',
  });

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
