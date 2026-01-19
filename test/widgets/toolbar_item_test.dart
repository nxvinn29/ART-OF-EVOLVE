import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/toolbar_item.dart';

void main() {
  testWidgets('ToolbarItem renders correctly and handles taps', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToolbarItem(
            icon: Icons.add,
            label: 'Add Item',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    // Verify icon and tooltip are present
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byTooltip('Add Item'), findsOneWidget);

    // Verify tap callback
    await tester.tap(find.byType(ToolbarItem));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
