import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry.g.dart';

/// Represents a user's journal entry.
///
/// A [JournalEntry] captures thoughts, feelings, and memories.
/// It supports rich content features like mood tracking, tags, prompts,
/// drawing indicators, and audio indicators. It is persisted using Hive with [typeId: 4].
@HiveType(typeId: 4)
class JournalEntry extends HiveObject {
  /// Unique identifier for the journal entry.
  @HiveField(0)
  final String id;

  /// The title of the entry.
  @HiveField(1)
  final String title;

  /// The main text content of the entry.
  @HiveField(2)
  final String content;

  /// The date and time when the entry was created.
  @HiveField(3)
  final DateTime date;

  /// The mood associated with the entry (e.g., 'Happy', 'Sad').
  @HiveField(4)
  final String mood;

  /// A list of tags to categorize the entry.
  @HiveField(5)
  final List<String> tags;

  /// The prompt that inspired this entry, if any.
  @HiveField(6)
  final String? prompt;

  /// A list of content blocks for rich text or mixed media support.
  /// Each block is a map containing type and data.
  @HiveField(7, defaultValue: [])
  final List<Map<String, dynamic>> contentBlocks;

  /// Indicates if the entry includes a drawing.
  ///
  /// Used to render a specific drawing widget or icon in the list view.
  /// Defaults to `false`.
  @HiveField(8, defaultValue: false)
  final bool hasDrawing;

  /// Indicates if the entry includes an audio recording.
  ///
  /// Used to show audio playback controls.
  /// Defaults to `false`.
  @HiveField(9, defaultValue: false)
  final bool hasAudio;

  /// Optional reminder time associated with this entry.
  @HiveField(10)
  final DateTime? reminderTime;

  /// Creates a [JournalEntry].
  ///
  /// If [id] is not provided, a UUID v4 is generated.
  /// If [date] is not provided, the current time is used.
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

  /// Creates a copy of this [JournalEntry] with the given fields replaced by the new values.
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
