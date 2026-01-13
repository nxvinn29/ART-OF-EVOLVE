import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/features/self_care/data/journal_repository.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';

// Manual mock for Hive Box
class MockBox<T> extends Fake implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override
  T? get(dynamic key, {T? defaultValue}) => _data[key] ?? defaultValue;

  @override
  Future<void> put(dynamic key, T value) async => _data[key] = value;

  @override
  Future<void> delete(dynamic key) async => _data.remove(key);

  @override
  Iterable<T> get values => _data.values;
}

void main() {
  late MockBox<JournalEntry> mockBox;
  late JournalRepository repository;

  setUp(() {
    mockBox = MockBox<JournalEntry>();
    repository = JournalRepository(mockBox);
  });

  group('JournalRepository', () {
    test('getEntries returns empty list when no entries exist', () async {
      // Act
      final result = await repository.getEntries();

      // Assert
      expect(result, isEmpty);
    });

    test('saveEntry successfully saves an entry', () async {
      // Arrange
      final entry = JournalEntry(
        title: 'My Day',
        content: 'Today was great!',
        mood: 'Happy',
      );

      // Act
      await repository.saveEntry(entry);
      final entries = await repository.getEntries();

      // Assert
      expect(entries, hasLength(1));
      expect(entries.first.title, 'My Day');
      expect(entries.first.content, 'Today was great!');
      expect(entries.first.mood, 'Happy');
    });

    test('getEntries returns all saved entries', () async {
      // Arrange
      final entry1 = JournalEntry(
        title: 'Entry 1',
        content: 'Content 1',
        mood: 'Happy',
      );
      final entry2 = JournalEntry(
        title: 'Entry 2',
        content: 'Content 2',
        mood: 'Calm',
      );
      final entry3 = JournalEntry(
        title: 'Entry 3',
        content: 'Content 3',
        mood: 'Excited',
      );

      // Act
      await repository.saveEntry(entry1);
      await repository.saveEntry(entry2);
      await repository.saveEntry(entry3);
      final entries = await repository.getEntries();

      // Assert
      expect(entries, hasLength(3));
      expect(
        entries.map((e) => e.title),
        containsAll(['Entry 1', 'Entry 2', 'Entry 3']),
      );
    });

    test('saveEntry updates existing entry with same ID', () async {
      // Arrange
      final entry = JournalEntry(
        title: 'Original Title',
        content: 'Original content',
        mood: 'Neutral',
      );
      await repository.saveEntry(entry);

      final updatedEntry = JournalEntry(
        id: entry.id, // Same ID
        title: 'Updated Title',
        content: 'Updated content',
        mood: 'Happy',
        createdAt: entry.createdAt,
      );

      // Act
      await repository.saveEntry(updatedEntry);
      final entries = await repository.getEntries();

      // Assert
      expect(entries, hasLength(1));
      expect(entries.first.title, 'Updated Title');
      expect(entries.first.content, 'Updated content');
      expect(entries.first.mood, 'Happy');
    });

    test('deleteEntry removes entry successfully', () async {
      // Arrange
      final entry = JournalEntry(
        title: 'To Delete',
        content: 'Will be removed',
        mood: 'Sad',
      );
      await repository.saveEntry(entry);

      // Act
      await repository.deleteEntry(entry.id);
      final entries = await repository.getEntries();

      // Assert
      expect(entries, isEmpty);
    });

    test('deleteEntry handles non-existent ID gracefully', () async {
      // Arrange
      final entry = JournalEntry(
        title: 'Exists',
        content: 'Content',
        mood: 'Happy',
      );
      await repository.saveEntry(entry);

      // Act - delete non-existent entry
      await repository.deleteEntry('non-existent-id');
      final entries = await repository.getEntries();

      // Assert - existing entry should still be there
      expect(entries, hasLength(1));
      expect(entries.first.title, 'Exists');
    });

    test('saveEntry preserves entry ID', () async {
      // Arrange
      final entry = JournalEntry(
        title: 'ID Test',
        content: 'Testing ID',
        mood: 'Neutral',
      );
      final originalId = entry.id;

      // Act
      await repository.saveEntry(entry);
      final entries = await repository.getEntries();

      // Assert
      expect(entries.first.id, originalId);
    });

    test('saveEntry preserves createdAt timestamp', () async {
      // Arrange
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final entry = JournalEntry(
        title: 'Timestamp Test',
        content: 'Testing timestamp',
        mood: 'Happy',
        createdAt: createdAt,
      );

      // Act
      await repository.saveEntry(entry);
      final entries = await repository.getEntries();

      // Assert
      expect(entries.first.createdAt, createdAt);
    });

    test('multiple delete operations work correctly', () async {
      // Arrange
      final entries = List.generate(
        5,
        (i) => JournalEntry(
          title: 'Entry $i',
          content: 'Content $i',
          mood: 'Happy',
        ),
      );
      for (var entry in entries) {
        await repository.saveEntry(entry);
      }

      // Act - delete every other entry
      await repository.deleteEntry(entries[0].id);
      await repository.deleteEntry(entries[2].id);
      await repository.deleteEntry(entries[4].id);
      final remaining = await repository.getEntries();

      // Assert
      expect(remaining, hasLength(2));
      expect(
        remaining.map((e) => e.title),
        containsAll(['Entry 1', 'Entry 3']),
      );
    });
  });
}
