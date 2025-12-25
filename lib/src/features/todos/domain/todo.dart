import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

/// Represents a simple task or to-do item.
///
/// A [Todo] has a title, completion status, and category.
/// It also supports soft deletion tracking.
/// Persisted using Hive with [typeId: 1].
@HiveType(typeId: 1)
class Todo extends HiveObject {
  /// Unique identifier for the todo.
  @HiveField(0)
  final String id;

  /// The description of the task to be done.
  @HiveField(1)
  final String title;

  /// Whether the task has been completed.
  @HiveField(2)
  final bool isCompleted;

  /// The date and time when the todo was created.
  @HiveField(3)
  final DateTime createdAt;

  /// The category to which the todo belongs (e.g., "Work", "Personal").
  @HiveField(4)
  final String category;

  /// Whether the todo has been soft-deleted.
  @HiveField(5)
  final bool isDeleted;

  /// The date and time when the todo was soft-deleted, if applicable.
  @HiveField(6)
  final DateTime? deletedAt;

  /// Creates a [Todo].
  ///
  /// If [id] is not provided, a UUID v4 is generated.
  /// If [createdAt] is not provided, the current time is used.
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

  /// Creates a copy of this [Todo] with the given fields replaced by the new values.
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
