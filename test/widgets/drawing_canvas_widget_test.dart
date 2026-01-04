import 'package:art_of_evolve/src/features/self_care/presentation/widgets/drawing_canvas_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DrawingCanvasWidget renders correctly', (tester) async {
    // We can pass a real DrawingController since it works without platform channels for basic init
    final controller = DrawingController();

    await tester.pumpWidget(
      MaterialApp(
        home: DrawingCanvasWidget(onSave: (_) {}, controller: controller),
      ),
    );

    // Verify AppBar
    expect(find.text('Draw'), findsOneWidget);

    // Verify Actions
    expect(find.byIcon(Icons.check), findsOneWidget);

    // Verify DrawingBoard
    expect(find.byType(DrawingBoard), findsOneWidget);

    // Cleanup
    controller.dispose();
  });
}
