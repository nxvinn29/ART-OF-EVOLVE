import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_controller.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  String _selectedMood = 'Neutral';
  final List<String> _tags = [];
  String? _currentPrompt;

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

  final List<String> _prompts = [
    "What made you smile today?",
    "What is one thing you learned?",
    "Who are you grateful for?",
    "What challenge did you overcome?",
    "How are you feeling right now?",
    "What is your goal for tomorrow?",
  ];

  void _generatePrompt() {
    setState(() {
      _currentPrompt = (_prompts..shuffle()).first;
      _contentController.text = "$_currentPrompt\n\n";
    });
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt Generator
            if (_currentPrompt == null)
              TextButton.icon(
                onPressed: _generatePrompt,
                icon: const Icon(Icons.lightbulb_outline, size: 18),
                label: const Text("Get Inspired"),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentPrompt!,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _currentPrompt = null),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Mood Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood['label'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Row(
                        children: [
                          Icon(
                            mood['icon'],
                            size: 18,
                            color: isSelected ? Colors.white : mood['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(mood['label']),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: mood['color'],
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedMood = mood['label']);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title (optional)',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // Content
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Tags Input
            const Divider(),
            Wrap(
              spacing: 8,
              children: _tags
                  .map(
                    (tag) => Chip(
                      label: Text('#$tag'),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                      deleteIcon: const Icon(Icons.close, size: 14),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                hintText: 'Add a tag...',
                prefixIcon: Icon(Icons.tag, size: 16),
                border: InputBorder.none,
              ),
              onSubmitted: _addTag,
            ),
          ],
        ),
      ),
    );
  }

  void _saveEntry() {
    if (_contentController.text.isNotEmpty) {
      ref
          .read(journalControllerProvider.notifier)
          .addEntry(
            _titleController.text,
            _contentController.text,
            _selectedMood,
            tags: _tags,
            prompt: _currentPrompt,
          );
      Navigator.pop(context);
    }
  }
}
