import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/self_care_screen.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_controller.dart';
import 'package:art_of_evolve/src/features/self_care/domain/journal_entry.dart';

// Mock JournalController using StateNotifier
class MockJournalController
    extends StateNotifier<AsyncValue<List<JournalEntry>>>
    implements JournalController {
  MockJournalController() : super(const AsyncData([]));

  @override
  Future<void> loadEntries() async {}

  @override
  Future<void> deleteEntry(String id) async {}

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
}

void main() {
  testWidgets('SelfCareScreen displays all tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalControllerProvider.overrideWith(
            (ref) => MockJournalController(),
          ),
        ],
        child: const MaterialApp(home: SelfCareScreen()),
      ),
    );

    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('Gratitude'), findsOneWidget);
    expect(find.text('Meditation'), findsOneWidget);
  });

  testWidgets('Journal tab shows empty state when no entries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalControllerProvider.overrideWith(
            (ref) => MockJournalController(),
          ),
        ],
        child: const MaterialApp(home: SelfCareScreen(initialIndex: 0)),
      ),
    );
    // Trigger frame to ensure TabView paints
    await tester.pump();

    expect(find.text('Write your first journal entry.'), findsOneWidget);
  });
}
