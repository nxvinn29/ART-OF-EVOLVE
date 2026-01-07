import 'package:hive/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 6)
/// Represents the user's progress and gamification stats.
@HiveType(typeId: 6)
class UserStats extends HiveObject {
  @HiveField(0)
  /// Current accumulated experience points.
  final int currentXp;

  @HiveField(1)
  /// Current user level.
  final int level;

  @HiveField(2)
  /// Total number of habits completed since start.
  final int totalHabitsCompleted;

  @HiveField(3)
  /// Current streak of daily activity.
  final int currentStreak;

  @HiveField(4)
  /// List of IDs of unlocked badges.
  final List<String> unlockedBadgeIds;

  /// Creates a [UserStats] instance.
  ///
  /// Defaults to:
  /// - [currentXp]: 0
  /// - [level]: 1
  /// - [totalHabitsCompleted]: 0
  /// - [currentStreak]: 0
  /// - [unlockedBadgeIds]: Empty list
  UserStats({
    this.currentXp = 0,
    this.level = 1,
    this.totalHabitsCompleted = 0,
    this.currentStreak = 0,
    this.unlockedBadgeIds = const [],
  });

  /// Creates a copy of this [UserStats] with the given fields replaced with the new values.
  UserStats copyWith({
    int? currentXp,
    int? level,
    int? totalHabitsCompleted,
    int? currentStreak,
    List<String>? unlockedBadgeIds,
  }) {
    return UserStats(
      currentXp: currentXp ?? this.currentXp,
      level: level ?? this.level,
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }
}
