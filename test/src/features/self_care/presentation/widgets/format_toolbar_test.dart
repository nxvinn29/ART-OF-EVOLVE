import 'package:art_of_evolve/src/features/self_care/presentation/widgets/format_toolbar.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/toolbar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FormatToolbar renders all items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatToolbar(
            onTextTap: () {},
            onChecklistTap: () {},
            onVoiceTap: () {},
            onDrawTap: () {},
            onImageTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(ToolbarItem), findsNWidgets(5));
    expect(find.byIcon(Icons.text_fields), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);
  });
}
