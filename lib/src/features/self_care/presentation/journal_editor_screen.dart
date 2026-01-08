import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'journal_controller.dart';
import 'widgets/drawing_canvas_widget.dart';
import 'widgets/format_toolbar.dart';
import 'widgets/voice_recorder_widget.dart';

/// A rich text editor for creating journal entries.
///
/// Supports various content blocks:
/// - Text (with multiple paragraphs)
/// - Images
/// - Drawings
/// - Voice notes
/// - Checklists
///
/// Users can assign moods and tags to their entries.
class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  final List<Map<String, dynamic>> _blocks = [
    {'type': 'text', 'data': TextEditingController()},
  ];
  String _selectedMood = 'Neutral';
  final List<String> _tags = [];
  String? _currentPrompt;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _moods = [
    {
      'label': 'Happy',
      'icon': Icons.sentiment_very_satisfied,
      'color': Colors.amber,
    },
    {'label': 'Calm', 'icon': Icons.spa, 'color': Colors.green},
    {'label': 'Neutral', 'icon': Icons.sentiment_neutral, 'color': Colors.grey},
    {
      'label': 'Sad',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.blueGrey,
    },
    {'label': 'Stress', 'icon': Icons.bolt, 'color': Colors.redAccent},
    {'label': 'Grateful', 'icon': Icons.favorite, 'color': Colors.pink},
  ];

  @override
  void dispose() {
    for (var block in _blocks) {
      if (block['type'] == 'text') {
        (block['data'] as TextEditingController).dispose();
      }
    }
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  /// Adds a new content block to the editor.
  ///
  /// [type] can be 'text', 'image', 'drawing', 'voice', or 'checklist'.
  /// [data] holds the initial content for that block.
  void _addBlock(String type, dynamic data) {
    setState(() {
      _blocks.add({'type': type, 'data': data});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _addTextBlock() {
    _addBlock('text', TextEditingController());
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _addBlock('image', image.path);
    }
  }

  void _openDrawingCanvas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingCanvasWidget(
          onSave: (path) {
            _addBlock('drawing', path);
          },
        ),
      ),
    );
  }

  /// Captures the current journal state and saves it via the controller.
  ///
  /// This extracts text, checklist items, and legacy content summaries
  /// before passing the data to the [JournalController].
  void _saveEntry() {
    final title = _titleController.text;
    // Prepare blocks for saving (extract text from controllers)
    final savedBlocks = _blocks.map((block) {
      if (block['type'] == 'text') {
        return {
          'type': 'text',
          'data': (block['data'] as TextEditingController).text,
        };
      } else if (block['type'] == 'checklist') {
        return {
          'type': 'checklist',
          'data': (block['data'] as List<Map<String, dynamic>>).map((item) {
            return {
              'checked': item['checked'],
              'text': (item['controller'] as TextEditingController).text,
            };
          }).toList(),
        };
      }
      return block;
    }).toList();

    // Create legacy content summary
    var legacyContent = '';
    if (savedBlocks.isNotEmpty && savedBlocks.first['type'] == 'text') {
      legacyContent = savedBlocks.first['data'];
    } else {
      legacyContent = 'Rich content entry';
    }

    ref
        .read(journalControllerProvider.notifier)
        .addEntry(
          title,
          legacyContent,
          _selectedMood,
          tags: _tags,
          prompt: _currentPrompt,
          contentBlocks: savedBlocks,
          hasDrawing: savedBlocks.any((b) => b['type'] == 'drawing'),
          hasAudio: savedBlocks.any((b) => b['type'] == 'voice'),
        );
    Navigator.pop(context);
  }

  Widget _buildBlockWidget(int index, Map<String, dynamic> block) {
    switch (block['type']) {
      case 'text':
        return TextField(
          controller: block['data'] as TextEditingController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Write something...',
            border: InputBorder.none,
          ),
        );
      case 'image':
      case 'drawing':
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Image.file(File(block['data'] as String)),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => setState(() => _blocks.removeAt(index)),
            ),
          ],
        );
      case 'voice':
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Voice Note'),
                  const Spacer(),
                  Text(block['duration'] ?? ''),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => setState(() => _blocks.removeAt(index)),
            ),
          ],
        );
      case 'checklist':
        final children = (block['data'] as List<Map<String, dynamic>>)
            .asMap()
            .entries
            .map<Widget>((entry) {
              final itemIndex = entry.key;
              final item = entry.value;
              return Row(
                children: [
                  Checkbox(
                    value: item['checked'] ?? false,
                    onChanged: (val) {
                      setState(() {
                        item['checked'] = val;
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: item['controller'] as TextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'List item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () {
                      setState(() {
                        (block['data'] as List).removeAt(itemIndex);
                      });
                    },
                  ),
                ],
              );
            })
            .toList();

        children.add(
          TextButton.icon(
            onPressed: () {
              setState(() {
                (block['data'] as List<Map<String, dynamic>>).add({
                  'checked': false,
                  'controller': TextEditingController(),
                });
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        );
        return Column(children: children);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        actions: [
          IconButton(onPressed: _saveEntry, icon: const Icon(Icons.check)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // Mood & Prompt (Keep simplified for brevity in refactor)
                _buildMoodSelector(),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ..._blocks.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildBlockWidget(entry.key, entry.value),
                  );
                }),
                const SizedBox(height: 100), // Space for FAB/Toolbar
              ],
            ),
          ),
          FormatToolbar(
            onTextTap: _addTextBlock,
            onChecklistTap: () {
              _addBlock('checklist', [
                {'checked': false, 'controller': TextEditingController()},
              ]);
            },
            onVoiceTap: () {
              _addBlock('voice_recorder', null); // Placeholder to show recorder
            },
            onDrawTap: _openDrawingCanvas,
            onImageTap: _addImage,
          ),
          if (_blocks.isNotEmpty && _blocks.last['type'] == 'voice_recorder')
            VoiceRecorderWidget(
              onRecordingComplete: (path, duration) {
                setState(() {
                  _blocks.removeLast(); // Remove recorder
                  _blocks.add({
                    'type': 'voice',
                    'data': path,
                    'duration': '$duration s',
                  });
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _moods.map((mood) {
          final isSelected = _selectedMood == mood['label'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(mood['label']),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedMood = mood['label']);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
