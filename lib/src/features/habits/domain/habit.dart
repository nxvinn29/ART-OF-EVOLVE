import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int color; // Store as ARGB int

  @HiveField(4)
  final int iconCodePoint; // Store icon data

  @HiveField(5)
  final List<DateTime> completedDates;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool isDaily;

  @HiveField(8)
  final DateTime? reminderTime; // Store as DateTime, ignore date part, use time only

  Habit({
    String? id,
    required this.title,
    this.description = '',
    required this.color,
    required this.iconCodePoint,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    this.isDaily = true,
    this.reminderTime,
  }) : id = id ?? const Uuid().v4(),
       completedDates = completedDates ?? [],
       createdAt = createdAt ?? DateTime.now();

  bool isCompletedOn(DateTime date) {
    return completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  int get currentStreak {
    var streak = 0;
    var date = DateTime.now();

    // If not completed today, check if the streak is still alive from yesterday
    if (!isCompletedOn(date)) {
      date = date.subtract(const Duration(days: 1));
      if (!isCompletedOn(date)) {
        return 0;
      }
    }

    while (isCompletedOn(date)) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
