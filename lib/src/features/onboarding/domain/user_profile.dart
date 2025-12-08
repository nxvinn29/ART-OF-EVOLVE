import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime wakeTime; // Storing as DateTime for simplicity in Hive

  @HiveField(3)
  final String mood;

  @HiveField(4)
  final String primaryGoal;

  @HiveField(5)
  final bool hasCompletedOnboarding;

  UserProfile({
    String? id,
    this.name = '',
    required this.wakeTime,
    this.mood = 'Neutral',
    this.primaryGoal = '',
    this.hasCompletedOnboarding = false,
  }) : id = id ?? const Uuid().v4();

  UserProfile copyWith({
    String? name,
    DateTime? wakeTime,
    String? mood,
    String? primaryGoal,
    bool? hasCompletedOnboarding,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      wakeTime: wakeTime ?? this.wakeTime,
      mood: mood ?? this.mood,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
