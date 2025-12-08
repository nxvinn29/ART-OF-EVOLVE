import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String category; // e.g., "Work", "Personal"

  @HiveField(5) // New field
  final bool isDeleted;

  @HiveField(6) // New field
  final DateTime? deletedAt;

  Todo({
    String? id,
    required this.title,
    this.isCompleted = false,
    this.isDeleted = false,
    this.deletedAt,
    DateTime? createdAt,
    this.category = 'General',
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    String? category,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}
