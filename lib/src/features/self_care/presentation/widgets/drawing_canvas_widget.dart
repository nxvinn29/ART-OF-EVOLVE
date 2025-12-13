import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:path_provider/path_provider.dart';

class DrawingCanvasWidget extends StatefulWidget {
  final Function(String imagePath) onSave;

  const DrawingCanvasWidget({super.key, required this.onSave});

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
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
            onPressed: () {
              _saveDrawing().then((_) {
                if (mounted) Navigator.pop(context);
              });
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
