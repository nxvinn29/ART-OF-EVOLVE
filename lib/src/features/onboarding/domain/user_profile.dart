import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

/// Represents the user's profile information.
///
/// Stores personal details, preferences, and onboarding status.
/// This class is immutable (except for Hive internal state) and uses value equality.
///
/// - Key fields:
///   - [id]: Unique identifier.
///   - [name]: Display name.
///   - [wakeTime]: Scheduled wake-up time.
/// Persisted using Hive with [typeId: 3].
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

  /// Creates a [UserProfile].
  ///
  /// - [id]: Unique identifier (defaults to UUID v4).
  /// - [name]: User's display name.
  /// - [wakeTime]: Typical wake-up time.
  /// - [mood]: Current mood state.
  /// - [primaryGoal]: Main objective for using the app.
  /// - [hasCompletedOnboarding]: Whether the user has finished setup.
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
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.wakeTime == wakeTime &&
        other.mood == mood &&
        other.primaryGoal == primaryGoal &&
        other.hasCompletedOnboarding == hasCompletedOnboarding;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        wakeTime.hashCode ^
        mood.hashCode ^
        primaryGoal.hashCode ^
        hasCompletedOnboarding.hashCode;
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, wakeTime: $wakeTime, mood: $mood, primaryGoal: $primaryGoal, hasCompletedOnboarding: $hasCompletedOnboarding)';
  }
}
