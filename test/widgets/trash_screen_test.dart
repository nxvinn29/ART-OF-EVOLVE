import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:art_of_evolve/src/features/account/presentation/trash_screen.dart';
import 'package:art_of_evolve/src/features/todos/domain/todo.dart';
import 'package:art_of_evolve/src/features/todos/presentation/todos_controller.dart';

void main() {
  group('TrashScreen', () {
    testWidgets('renders empty state when no deleted todos', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deletedTodosProvider.overrideWith((ref) => const AsyncData([])),
          ],
          child: const MaterialApp(home: TrashScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Trash'), findsOneWidget);
      expect(find.text('Trash is empty'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('renders list of deleted todos', (tester) async {
      final todo = Todo(id: '1', title: 'Deleted Task', isDeleted: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deletedTodosProvider.overrideWith((ref) => AsyncData([todo])),
          ],
          child: const MaterialApp(home: TrashScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Deleted Task'), findsOneWidget);
      expect(find.byIcon(Icons.restore), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });
  });
}
