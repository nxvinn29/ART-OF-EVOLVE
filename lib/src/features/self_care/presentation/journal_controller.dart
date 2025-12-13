import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/journal_entry.dart';
import '../data/journal_repository.dart';
import '../../../core/data/repository_interfaces.dart';
import '../../../services/notifications/notification_service.dart';

final journalControllerProvider =
    StateNotifierProvider<JournalController, AsyncValue<List<JournalEntry>>>((
      ref,
    ) {
      final repository = ref.watch(journalRepositoryProvider);
      return JournalController(repository);
    });

class JournalController extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final IJournalRepository _repository;

  JournalController(this._repository) : super(const AsyncLoading()) {
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final entries = await _repository.getEntries();
      // Sort by date descending
      entries.sort((a, b) => b.date.compareTo(a.date));
      state = AsyncData(entries);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

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
        await NotificationService().scheduleReminder(
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

  Future<void> deleteEntry(String id) async {
    try {
      await NotificationService().cancelReminder(id.hashCode);
      await _repository.deleteEntry(id);
      await loadEntries();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
