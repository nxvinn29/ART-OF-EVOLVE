import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/todos/presentation/widgets/add_todo_dialog.dart';

void main() {
  group('AddTodoDialog Widget Tests', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: AddTodoDialog())),
        ),
      );

      expect(find.text('New Task'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Task Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget); // Default value
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('can enter text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: AddTodoDialog())),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Buy milk');
      expect(find.text('Buy milk'), findsOneWidget);
    });

    testWidgets('can select category', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: AddTodoDialog())),
        ),
      );

      // Open dropdown
      await tester.tap(find.text('Personal'));
      await tester.pumpAndSettle();

      // Select 'Work'
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(DropdownButton<String>, 'Work'),
        findsOneWidget,
      );
    });
  });
}
