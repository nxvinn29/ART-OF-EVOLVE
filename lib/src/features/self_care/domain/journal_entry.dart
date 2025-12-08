import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 4)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String mood; // Optional tag

  @HiveField(5)
  final List<String> tags;

  @HiveField(6)
  final String? prompt;

  JournalEntry({
    String? id,
    this.title = '',
    required this.content,
    DateTime? date,
    this.mood = '',
    this.tags = const [],
    this.prompt,
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  JournalEntry copyWith({
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    String? prompt,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      prompt: prompt ?? this.prompt,
    );
  }
}
