import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_screen.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_controller.dart';

void main() {
  group('JournalScreen Widget Tests', () {
    testWidgets('displays loading indicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalControllerProvider.overrideWith((ref) {
              return TestJournalController(const AsyncLoading());
            }),
          ],
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no entries', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalControllerProvider.overrideWith((ref) {
              return TestJournalController(const AsyncData([]));
            }),
          ],
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('No entries', findRichText: true), findsAny);
    });

    testWidgets('displays list of journal entries', (
      WidgetTester tester,
    ) async {
      final entries = [
        JournalEntry(
          title: 'My First Entry',
          content: 'Today was great!',
          mood: 'happy',
        ),
        JournalEntry(
          title: 'Reflection',
          content: 'Thinking about my goals',
          mood: 'calm',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalControllerProvider.overrideWith((ref) {
              return TestJournalController(AsyncData(entries));
            }),
          ],
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My First Entry'), findsOneWidget);
      expect(find.text('Reflection'), findsOneWidget);
    });

    testWidgets('add entry button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalControllerProvider.overrideWith((ref) {
              return TestJournalController(const AsyncData([]));
            }),
          ],
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('displays error message on error', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalControllerProvider.overrideWith((ref) {
              return TestJournalController(
                AsyncError(Exception('Failed'), StackTrace.empty),
              );
            }),
          ],
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsAny);
    });
  });
}

class TestJournalController
    extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  TestJournalController(AsyncValue<List<JournalEntry>> initialState)
    : super(initialState);

  @override
  Future<void> loadEntries() async {}

  @override
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
  }) async {}

  @override
  Future<void> deleteEntry(String id) async {}
}
