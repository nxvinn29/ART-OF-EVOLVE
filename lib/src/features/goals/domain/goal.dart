import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

/// Represents a user's goal in the application.
///
/// A [Goal] tracks a specific objective a user wants to achieve by a certain [targetDate].
/// It is persisted using Hive with [typeId: 2].
@HiveType(typeId: 2)
class Goal extends HiveObject {
  /// Unique identifier for the goal.
  @HiveField(0)
  final String id;

  /// The title of the goal.
  @HiveField(1)
  final String title;

  /// A detailed description of the goal.
  @HiveField(2)
  final String description;

  /// The date by which the user aims to achieve this goal.
  ///
  /// This serves as the deadline for the goal progress tracking.
  @HiveField(3)
  final DateTime targetDate;

  /// Whether the goal has been achieved.
  ///
  /// Defaults to `false` when a goal is first created.
  /// Set to `true` when the user marks the goal as completed.
  @HiveField(4)
  final bool isAchieved;

  /// The date and time when the goal was created.
  @HiveField(5)
  final DateTime createdAt;

  /// Creates a new [Goal] instance.
  ///
  /// [id] Optional unique identifier. If null, a UUID v4 is generated.
  /// [title] The obligatory title of the goal.
  /// [description] Optional description, defaults to empty string.
  /// [targetDate] The deadline for achieving the goal.
  /// [isAchieved] Status of the goal, defaults to false.
  /// [createdAt] Creation timestamp, defaults to [DateTime.now].
  Goal({
    String? id,
    required this.title,
    this.description = '',
    required this.targetDate,
    this.isAchieved = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Creates a copy of this goal with customized properties.
  ///
  /// [title] New title for the goal.
  /// [description] New description for the goal.
  /// [targetDate] New target date for the goal.
  /// [isAchieved] New achievement status.
  ///
  /// Returns a new [Goal] instance with the updated fields, preserving other original values.
  Goal copyWith({
    String? title,
    String? description,
    DateTime? targetDate,
    bool? isAchieved,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      isAchieved: isAchieved ?? this.isAchieved,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'Goal(id: $id, title: $title, targetDate: $targetDate, isAchieved: $isAchieved)';
  }
}
