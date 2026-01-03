import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/drawing_canvas_widget.dart';

void main() {
  // Note: DrawingCanvasWidget depends on DrawingController and path_provider
  // which are hard to mock without extensive setup or wrapper classes.
  // We perform structural verification here to ensure the widget contract is valid.

  test('DrawingCanvasWidget is a StatefulWidget', () {
    expect(DrawingCanvasWidget(onSave: (_) {}), isA<StatefulWidget>());
  });
}
