import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime targetDate;

  @HiveField(4)
  final bool isAchieved;

  @HiveField(5)
  final DateTime createdAt;

  Goal({
    String? id,
    required this.title,
    this.description = '',
    required this.targetDate,
    this.isAchieved = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
  
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
}
