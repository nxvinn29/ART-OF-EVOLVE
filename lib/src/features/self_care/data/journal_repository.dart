import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/journal_entry.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

/// Provider for accessing the [JournalRepository] instance.
///
/// This provider creates a singleton instance of [JournalRepository]
/// with the Hive journal box for data persistence.
final journalRepositoryProvider = Provider<IJournalRepository>((ref) {
  return JournalRepository(HiveService.journalBox);
});

/// Repository for managing journal entry data persistence using Hive.
///
/// This repository provides CRUD operations for [JournalEntry] entities
/// and serves as the single source of truth for journal data in the application.
/// All journal entries are stored locally using Hive for offline-first functionality.
///
/// ## Features
/// - Create and save journal entries
/// - Retrieve all journal entries
/// - Delete journal entries by ID
/// - Automatic data persistence
/// - Offline-first architecture
///
/// ## Usage Example
/// ```dart
/// final repository = ref.watch(journalRepositoryProvider);
///
/// // Save a new journal entry
/// final entry = JournalEntry(
///   title: 'My Day',
///   content: 'Today was amazing!',
///   mood: 'Happy',
/// );
/// await repository.saveEntry(entry);
///
/// // Retrieve all entries
/// final entries = await repository.getEntries();
///
/// // Delete an entry
/// await repository.deleteEntry(entry.id);
/// ```
class JournalRepository implements IJournalRepository {
  /// The Hive box used for storing journal entry data.
  final Box<JournalEntry> _box;

  /// Creates a [JournalRepository] with the given Hive [_box].
  ///
  /// The box should be properly initialized before passing it to this constructor.
  /// Typically, this is done through [HiveService.init()].
  JournalRepository(this._box);

  /// Retrieves all journal entries from local storage.
  ///
  /// Returns a [Future] that completes with a list of all stored [JournalEntry] objects.
  /// The list will be empty if no journal entries have been created yet.
  /// Entries are returned in the order they were stored in Hive.
  ///
  /// ## Example
  /// ```dart
  /// final entries = await repository.getEntries();
  /// print('Found ${entries.length} journal entries');
  /// ```
  ///
  /// ## Performance
  /// This is a synchronous read from Hive, which is very fast.
  /// For large numbers of entries, consider implementing pagination.
  @override
  Future<List<JournalEntry>> getEntries() async {
    return _box.values.toList();
  }

  /// Saves a journal entry to local storage.
  ///
  /// If an entry with the same [JournalEntry.id] already exists, it will be updated.
  /// Otherwise, a new entry is created. The operation is asynchronous and completes
  /// when the data is persisted to disk.
  ///
  /// ## Parameters
  /// - [entry]: The journal entry to save. Must have a valid ID.
  ///
  /// ## Example
  /// ```dart
  /// final entry = JournalEntry(
  ///   title: 'Reflection',
  ///   content: 'Today I learned...',
  ///   mood: 'Thoughtful',
  ///   createdAt: DateTime.now(),
  /// );
  /// await repository.saveEntry(entry);
  /// ```
  ///
  /// ## Error Handling
  /// Throws an exception if the Hive box is not open or if there's
  /// a disk write error. Ensure proper error handling in calling code.
  @override
  Future<void> saveEntry(JournalEntry entry) async {
    await _box.put(entry.id, entry);
  }

  /// Deletes a journal entry from local storage by its ID.
  ///
  /// If no entry with the given [id] exists, this operation completes
  /// without error. The operation is asynchronous and completes when
  /// the data is removed from disk.
  ///
  /// ## Parameters
  /// - [id]: The unique identifier of the journal entry to delete.
  ///
  /// ## Example
  /// ```dart
  /// await repository.deleteEntry('entry-id-123');
  /// print('Entry deleted successfully');
  /// ```
  ///
  /// ## Important
  /// This operation is permanent and cannot be undone. Consider implementing
  /// a soft-delete mechanism if you need to recover deleted entries.
  @override
  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  /// Watches for changes to journal entries in real-time.
  ///
  /// Returns a [Stream] that emits the list of journal entries whenever
  /// the Hive box is updated (entry added, modified, or deleted).
  ///
  /// This enables parts of the app (like UI) to reactively update without
  /// manual polling.
  ///
  /// ## Returns
  /// A stream emitting lists of [JournalEntry] objects.
  @override
  Stream<List<JournalEntry>> watchEntries() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }
}

extension StreamStartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
