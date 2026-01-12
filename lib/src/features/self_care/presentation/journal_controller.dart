import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/journal_entry.dart';
import '../data/journal_repository.dart';
import '../../../core/data/repository_interfaces.dart';
import '../../../services/notifications/notification_service.dart';

/// Provider for the [JournalController].
final journalControllerProvider =
    StateNotifierProvider<JournalController, AsyncValue<List<JournalEntry>>>((
      ref,
    ) {
      final repository = ref.watch(journalRepositoryProvider);
      return JournalController(repository, NotificationService());
    });

/// Controller for managing journal entries.
///
/// This controller handles loading, creating, and deleting journal entries via the [IJournalRepository].
/// It also handles scheduling and canceling notifications for journal reminders.
///
/// Responsibilities:
/// - CRUD operations for [JournalEntry].
/// - Scheduling reminders via [NotificationService].
/// - Sorting entries by date.
class JournalController extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final IJournalRepository _repository;
  final INotificationService _notificationService;

  JournalController(this._repository, this._notificationService)
    : super(const AsyncLoading()) {
    loadEntries();
  }

  /// Loads all journal entries from the repository.
  ///
  /// Entries are sorted by [date] in descending order (newest first).
  /// Updates the state to [AsyncData] with the list of entries, or [AsyncError] on failure.
  Future<void> loadEntries() async {
    try {
      final entries = await _repository.getEntries();
      // Sort by date descending
      entries.sort((a, b) => b.date.compareTo(a.date));
      if (mounted) {
        state = AsyncData(entries);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  /// Adds a new journal entry with the given details.
  ///
  /// - [title]: The title of the entry.
  /// - [content]: The main content of the entry.
  /// - [mood]: The mood associated with the entry.
  /// - [tags]: Optional list of tags.
  /// - [prompt]: Optional prompt that inspired the entry.
  /// - [contentBlocks]: structured content blocks.
  /// - [hasDrawing]: whether the entry has a drawing.
  /// - [hasAudio]: whether the entry has an audio recording.
  /// - [reminderTime]: Optional time to schedule a reminder.
  ///
  /// If [reminderTime] is provided, a notification is scheduled.
  /// Triggers a reload of entries after saving.
  Future<void> addEntry(
    String title,
    String content,
    String mood, {
    List<String> tags = const [],
    String? prompt,
    List<Map<String, dynamic>> contentBlocks = const [],
    bool hasDrawing = false,
    bool hasAudio = false,
    DateTime? reminderTime,
  }) async {
    try {
      final entry = JournalEntry(
        title: title,
        content: content,
        mood: mood,
        tags: tags,
        prompt: prompt,
        contentBlocks: contentBlocks,
        hasDrawing: hasDrawing,
        hasAudio: hasAudio,
        reminderTime: reminderTime,
      );
      await _repository.saveEntry(entry);

      if (reminderTime != null) {
        await _notificationService.scheduleReminder(
          id: entry.id.hashCode,
          title: 'Journal Reminder',
          body: title.isNotEmpty ? title : 'Time to write in your journal!',
          scheduledDate: reminderTime,
        );
      }

      await loadEntries();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Deletes the journal entry with the specified [id].
  ///
  /// cancels any associated reminder and reloads the entries list.
  Future<void> deleteEntry(String id) async {
    try {
      await _notificationService.cancelReminder(id.hashCode);
      await _repository.deleteEntry(id);
      await loadEntries();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
