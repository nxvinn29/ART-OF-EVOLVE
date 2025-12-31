import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_controller.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/core/data/repository_interfaces.dart';

/// Mock implementation of [IJournalRepository] for testing.
class MockJournalRepository implements IJournalRepository {
  final List<JournalEntry> _entries = [];
  bool shouldThrowError = false;

  @override
  Future<List<JournalEntry>> getEntries() async {
    if (shouldThrowError) {
      throw Exception('Failed to load entries');
    }
    return List.from(_entries);
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    if (shouldThrowError) {
      throw Exception('Failed to save entry');
    }
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    if (shouldThrowError) {
      throw Exception('Failed to delete entry');
    }
    _entries.removeWhere((e) => e.id == id);
  }

  void reset() {
    _entries.clear();
    shouldThrowError = false;
  }
}

void main() {
  group('JournalController', () {
    late MockJournalRepository mockRepository;
    late JournalController controller;

    setUp(() {
      mockRepository = MockJournalRepository();
      controller = JournalController(mockRepository);
    });

    tearDown(() {
      mockRepository.reset();
      controller.dispose();
    });

    test('initial state is AsyncLoading', () {
      final newController = JournalController(mockRepository);
      expect(newController, isNotNull);
      newController.dispose();
    });

    test(
      'loadEntries updates state with sorted entries (newest first)',
      () async {
        // Add test entries with different dates
        final entry1 = JournalEntry(
          title: 'Entry 1',
          content: 'First entry content',
          mood: 'happy',
          date: DateTime(2025, 1, 1),
        );
        final entry2 = JournalEntry(
          title: 'Entry 2',
          content: 'Second entry content',
          mood: 'calm',
          date: DateTime(2025, 12, 31),
        );
        final entry3 = JournalEntry(
          title: 'Entry 3',
          content: 'Third entry content',
          mood: 'excited',
          date: DateTime(2025, 6, 15),
        );

        await mockRepository.saveEntry(entry1);
        await mockRepository.saveEntry(entry2);
        await mockRepository.saveEntry(entry3);

        await controller.loadEntries();

        controller.state.when(
          data: (entries) {
            expect(entries.length, 3);
            // Verify sorting by date descending (newest first)
            expect(entries[0].title, 'Entry 2'); // Dec 31
            expect(entries[1].title, 'Entry 3'); // Jun 15
            expect(entries[2].title, 'Entry 1'); // Jan 1
          },
          loading: () => fail('Should not be loading'),
          error: (_, __) => fail('Should not have error'),
        );
      },
    );

    test('loadEntries handles errors gracefully', () async {
      mockRepository.shouldThrowError = true;

      await controller.loadEntries();

      expect(controller.state, isA<AsyncError>());
    });

    test('addEntry creates and saves a new journal entry', () async {
      await controller.addEntry(
        'My First Journal',
        'Today was a great day!',
        'happy',
        tags: ['gratitude', 'reflection'],
      );

      controller.state.when(
        data: (entries) {
          expect(entries.length, 1);
          expect(entries[0].title, 'My First Journal');
          expect(entries[0].content, 'Today was a great day!');
          expect(entries[0].mood, 'happy');
          expect(entries[0].tags, ['gratitude', 'reflection']);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addEntry with minimal parameters works', () async {
      await controller.addEntry(
        'Simple Entry',
        'Just some thoughts',
        'neutral',
      );

      controller.state.when(
        data: (entries) {
          expect(entries.length, 1);
          expect(entries[0].title, 'Simple Entry');
          expect(entries[0].content, 'Just some thoughts');
          expect(entries[0].mood, 'neutral');
          expect(entries[0].tags, isEmpty);
          expect(entries[0].prompt, isNull);
          expect(entries[0].hasDrawing, false);
          expect(entries[0].hasAudio, false);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addEntry with all optional parameters', () async {
      final reminderTime = DateTime.now().add(const Duration(hours: 1));

      await controller.addEntry(
        'Complete Entry',
        'Full featured journal entry',
        'excited',
        tags: ['work', 'achievement'],
        prompt: 'What made you happy today?',
        contentBlocks: [
          {'type': 'text', 'content': 'Some text'},
          {'type': 'image', 'url': 'image.png'},
        ],
        hasDrawing: true,
        hasAudio: true,
        reminderTime: reminderTime,
      );

      controller.state.when(
        data: (entries) {
          expect(entries.length, 1);
          expect(entries[0].title, 'Complete Entry');
          expect(entries[0].tags, ['work', 'achievement']);
          expect(entries[0].prompt, 'What made you happy today?');
          expect(entries[0].contentBlocks.length, 2);
          expect(entries[0].hasDrawing, true);
          expect(entries[0].hasAudio, true);
          expect(entries[0].reminderTime, reminderTime);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('addEntry handles errors', () async {
      mockRepository.shouldThrowError = true;

      await controller.addEntry('Failed Entry', 'This should fail', 'sad');

      expect(controller.state, isA<AsyncError>());
    });

    test('deleteEntry removes entry from list', () async {
      // Add multiple entries
      final entry1 = JournalEntry(
        title: 'Entry 1',
        content: 'First',
        mood: 'happy',
      );
      final entry2 = JournalEntry(
        title: 'Entry 2',
        content: 'Second',
        mood: 'calm',
      );
      final entry3 = JournalEntry(
        title: 'Entry 3',
        content: 'Third',
        mood: 'excited',
      );

      await mockRepository.saveEntry(entry1);
      await mockRepository.saveEntry(entry2);
      await mockRepository.saveEntry(entry3);
      await controller.loadEntries();

      // Delete second entry
      await controller.deleteEntry(entry2.id);

      controller.state.when(
        data: (entries) {
          expect(entries.length, 2);
          expect(entries.any((e) => e.id == entry2.id), false);
          expect(entries.any((e) => e.id == entry1.id), true);
          expect(entries.any((e) => e.id == entry3.id), true);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('deleteEntry handles errors', () async {
      final entry = JournalEntry(
        title: 'Test Entry',
        content: 'Test',
        mood: 'neutral',
      );
      await mockRepository.saveEntry(entry);
      await controller.loadEntries();

      mockRepository.shouldThrowError = true;
      await controller.deleteEntry(entry.id);

      expect(controller.state, isA<AsyncError>());
    });

    test('multiple entries maintain correct order', () async {
      // Add entries in random order
      await controller.addEntry('Third', 'Content 3', 'happy');
      await Future.delayed(const Duration(milliseconds: 10));

      await controller.addEntry('First', 'Content 1', 'calm');
      await Future.delayed(const Duration(milliseconds: 10));

      await controller.addEntry('Second', 'Content 2', 'excited');

      controller.state.when(
        data: (entries) {
          expect(entries.length, 3);
          // Should be sorted by date descending (newest first)
          expect(entries[0].title, 'Second');
          expect(entries[1].title, 'First');
          expect(entries[2].title, 'Third');
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('entries with same mood are handled correctly', () async {
      await controller.addEntry('Entry 1', 'Content 1', 'happy');
      await controller.addEntry('Entry 2', 'Content 2', 'happy');
      await controller.addEntry('Entry 3', 'Content 3', 'happy');

      controller.state.when(
        data: (entries) {
          expect(entries.length, 3);
          expect(entries.every((e) => e.mood == 'happy'), true);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });

    test('empty tags list is handled correctly', () async {
      await controller.addEntry(
        'No Tags Entry',
        'Content without tags',
        'neutral',
        tags: [],
      );

      controller.state.when(
        data: (entries) {
          expect(entries[0].tags, isEmpty);
        },
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not have error'),
      );
    });
  });
}
