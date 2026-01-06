import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

/// Represents a habit that the user wants to track.
///
/// A [Habit] contains properties for customization (title, color, icon)
/// and tracking data (completed dates). It is persisted using Hive with [typeId: 0].
@HiveType(typeId: 0)
class Habit extends HiveObject {
  /// Unique identifier for the habit.
  @HiveField(0)
  final String id;

  /// The title of the habit.
  @HiveField(1)
  final String title;

  /// A detailed description of the habit.
  @HiveField(2)
  final String description;

  /// The color associated with the habit, stored as an ARGB integer.
  @HiveField(3)
  final int color;

  /// The code point of the icon associated with the habit.
  @HiveField(4)
  final int iconCodePoint;

  /// A list of dates when this habit was completed.
  @HiveField(5)
  final List<DateTime> completedDates;

  /// The date and time when this habit was created.
  @HiveField(6)
  final DateTime createdAt;

  /// Whether this habit is intended to be done daily.
  @HiveField(7)
  final bool isDaily;

  /// Optional time for a reminder. The date part should be ignored.
  @HiveField(8)
  final DateTime? reminderTime;

  /// Creates a [Habit].
  ///
  /// If [id] is not provided, a UUID v4 is generated.
  /// If [completedDates] is not provided, an empty list is initialized.
  /// If [createdAt] is not provided, the current time is used.
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

  /// Checks if the habit was completed on the given [date].
  ///
  /// Compares year, month, and day.
  bool isCompletedOn(DateTime date) {
    return completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// Calculates the current streak of consecutive days the habit has been completed.
  ///
  /// The streak counts backwards from today (or yesterday if not completed today).
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

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, isDaily: $isDaily, completedDates: ${completedDates.length})';
  }
}
