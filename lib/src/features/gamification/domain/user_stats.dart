import 'package:hive/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 6)
class UserStats extends HiveObject {
  @HiveField(0)
  final int currentXp;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final int totalHabitsCompleted;

  @HiveField(3)
  final int currentStreak;

  @HiveField(4)
  final List<String> unlockedBadgeIds;

  UserStats({
    this.currentXp = 0,
    this.level = 1,
    this.totalHabitsCompleted = 0,
    this.currentStreak = 0,
    this.unlockedBadgeIds = const [],
  });

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
