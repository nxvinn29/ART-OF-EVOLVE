import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/format_toolbar.dart';
import 'package:art_of_evolve/src/core/constants/app_constants.dart';

void main() {
  testWidgets('FormatToolbar renders all items and handles callbacks', (
    tester,
  ) async {
    var textTaps = 0;
    var checkTaps = 0;
    var voiceTaps = 0;
    var drawTaps = 0;
    var imageTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatToolbar(
            onTextTap: () => textTaps++,
            onChecklistTap: () => checkTaps++,
            onVoiceTap: () => voiceTaps++,
            onDrawTap: () => drawTaps++,
            onImageTap: () => imageTaps++,
          ),
        ),
      ),
    );

    // Verify all icons are present
    expect(find.byIcon(Icons.text_fields), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
    expect(find.byIcon(Icons.brush_outlined), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);

    // Verify tooltips (labels)
    expect(find.byTooltip(AppConstants.toolbarText), findsOneWidget);
    expect(find.byTooltip(AppConstants.toolbarList), findsOneWidget);
    expect(find.byTooltip(AppConstants.toolbarVoice), findsOneWidget);
    expect(find.byTooltip(AppConstants.toolbarDraw), findsOneWidget);
    expect(find.byTooltip(AppConstants.toolbarImage), findsOneWidget);

    // Verify interaction
    await tester.tap(find.byIcon(Icons.text_fields));
    await tester.tap(find.byIcon(Icons.check_box_outlined));
    await tester.tap(find.byIcon(Icons.mic_none));
    await tester.tap(find.byIcon(Icons.brush_outlined));
    await tester.tap(find.byIcon(Icons.image_outlined));

    expect(textTaps, 1);
    expect(checkTaps, 1);
    expect(voiceTaps, 1);
    expect(drawTaps, 1);
    expect(imageTaps, 1);
  });
}
