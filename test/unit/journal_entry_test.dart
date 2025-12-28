import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';

void main() {
  group('JournalEntry Model Tests', () {
    test('should create a valid JournalEntry instance', () {
      final entry = JournalEntry(
        content: 'Today was a good day.',
        mood: 'Happy',
        tags: ['positive', 'reflection'],
      );

      expect(entry.content, 'Today was a good day.');
      expect(entry.mood, 'Happy');
      expect(entry.tags, contains('positive'));
      expect(entry.id, isNotNull);
      expect(entry.date, isNotNull);
      expect(entry.hasDrawing, false);
    });

    test('should update fields using copyWith', () {
      final entry = JournalEntry(content: 'Old Content', mood: 'Neutral');

      final updatedEntry = entry.copyWith(
        content: 'New Content',
        mood: 'Excited',
        hasAudio: true,
      );

      expect(updatedEntry.content, 'New Content');
      expect(updatedEntry.mood, 'Excited');
      expect(updatedEntry.hasAudio, true);
      expect(updatedEntry.id, entry.id);
    });

    test('should keep old values if copyWith is called with nulls', () {
      final entry = JournalEntry(content: 'Keep Me', mood: 'Calm');

      final sameEntry = entry.copyWith();

      expect(sameEntry.content, entry.content);
      expect(sameEntry.mood, entry.mood);
    });

    test('should handle content blocks correctly', () {
      final entry = JournalEntry(
        content: 'Rich text content',
        contentBlocks: [
          {'type': 'text', 'data': 'Hello'},
          {'type': 'image', 'data': 'path/to/image.png'},
        ],
      );

      expect(entry.contentBlocks.length, 2);
      expect(entry.contentBlocks.first['type'], 'text');
    });
  });
}
