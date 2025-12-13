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

  @HiveField(7, defaultValue: [])
  final List<Map<String, dynamic>> contentBlocks;

  @HiveField(8, defaultValue: false)
  final bool hasDrawing;

  @HiveField(9, defaultValue: false)
  final bool hasAudio;

  @HiveField(10)
  final DateTime? reminderTime;

  JournalEntry({
    String? id,
    this.title = '',
    required this.content,
    DateTime? date,
    this.mood = '',
    this.tags = const [],
    this.prompt,
    this.contentBlocks = const [],
    this.hasDrawing = false,
    this.hasAudio = false,
    this.reminderTime,
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  JournalEntry copyWith({
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    String? prompt,
    List<Map<String, dynamic>>? contentBlocks,
    bool? hasDrawing,
    bool? hasAudio,
    DateTime? reminderTime,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      prompt: prompt ?? this.prompt,
      contentBlocks: contentBlocks ?? this.contentBlocks,
      hasDrawing: hasDrawing ?? this.hasDrawing,
      hasAudio: hasAudio ?? this.hasAudio,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
