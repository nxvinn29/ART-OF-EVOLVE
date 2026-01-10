import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:path_provider/path_provider.dart';

/// A widget that provides a drawing canvas for users to express creativity.
///
/// Features include a basic drawing board with painting tools.
/// Can be injected with a [DrawingController] for testing purposes.
/// Users can save their drawings to the device's application documents directory.
class DrawingCanvasWidget extends StatefulWidget {
  /// Callback function triggered when the drawing is saved.
  /// Returns the path of the saved image file.
  final Function(String imagePath) onSave;

  /// Optional controller to manage the drawing state.
  /// Useful for testing or external control.
  final DrawingController? controller;

  /// Creates a [DrawingCanvasWidget].
  const DrawingCanvasWidget({super.key, required this.onSave, this.controller});

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  late final DrawingController _drawingController;

  @override
  void initState() {
    super.initState();
    _drawingController = widget.controller ?? DrawingController();
  }

  @override
  void dispose() {
    // Only dispose if we created it
    if (widget.controller == null) {
      _drawingController.dispose();
    }
    super.dispose();
  }

  Future<void> _saveDrawing() async {
    final imageData = (await _drawingController.getImageData())?.buffer
        .asUint8List();

    if (imageData != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(imageData);
      widget.onSave(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await _saveDrawing();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DrawingBoard(
              controller: _drawingController,
              background: Container(color: Colors.white),
              showDefaultActions: true,
              showDefaultTools: true,
            ),
          ),
        ],
      ),
    );
  }
}
