import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'journal_controller.dart';
import 'journal_editor_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'focus_timer_screen.dart';

class SelfCareScreen extends ConsumerWidget {
  const SelfCareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Self Care'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Journal', icon: Icon(Icons.book)),
              Tab(text: 'Focus', icon: Icon(Icons.timer)),
              Tab(text: 'Gratitude', icon: Icon(Icons.favorite)),
              Tab(text: 'Meditation', icon: Icon(Icons.self_improvement)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _JournalTab(),
            FocusTimerScreen(),
            _GratitudeTab(),
            _MeditationTab(),
          ],
        ),
      ),
    );
  }
}

class _JournalTab extends ConsumerWidget {
  const _JournalTab();

  static const List<Map<String, dynamic>> _moods = [
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

  Map<String, dynamic> _getMoodDetails(String label) {
    return _moods.firstWhere(
      (m) => m['label'] == label,
      orElse: () => {'label': label, 'icon': Icons.label, 'color': Colors.grey},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalControllerProvider);

    return Scaffold(
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Write your first journal entry.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          final sortedEntries = List.of(entries)
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            itemCount: sortedEntries.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              final moodDetails = _getMoodDetails(entry.mood);

              return Dismissible(
                key: Key(entry.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref
                      .read(journalControllerProvider.notifier)
                      .deleteEntry(entry.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mood Icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (moodDetails['color'] as Color)
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                moodDetails['icon'] as IconData,
                                color: moodDetails['color'] as Color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry.prompt != null &&
                                      entry.prompt!.isNotEmpty) ...[
                                    Text(
                                      entry.prompt!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  if (entry.title.isNotEmpty)
                                    Text(
                                      entry.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  Text(
                                    entry.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Date
                            Text(
                              DateFormat.MMMd().format(entry.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (entry.tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: entry.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JournalEditorScreen()),
          );
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}

class _GratitudeTab extends ConsumerWidget {
  const _GratitudeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalControllerProvider);

    return Scaffold(
      body: entriesAsync.when(
        data: (entries) {
          final gratitudeEntries = entries
              .where((e) => e.mood == 'Grateful')
              .toList();

          if (gratitudeEntries.isEmpty) {
            return const Center(
              child: Text('What are you grateful for today?'),
            );
          }
          return ListView.builder(
            itemCount: gratitudeEntries.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final entry = gratitudeEntries[index];
              return Card(
                color: Colors.pink.shade50,
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.pink),
                  title: Text(
                    entry.content,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(DateFormat.MMMd().format(entry.date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      ref
                          .read(journalControllerProvider.notifier)
                          .deleteEntry(entry.id);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGratitudeDialog(context, ref),
        label: const Text('I am grateful for...'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddGratitudeDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('I am grateful for...'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Family, coffee, sunshine...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(journalControllerProvider.notifier)
                    .addEntry('', controller.text, 'Grateful');
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _MeditationTab extends StatefulWidget {
  const _MeditationTab();

  @override
  State<_MeditationTab> createState() => _MeditationTabState();
}

class _MeditationTabState extends State<_MeditationTab> {
  // Using audiplayers for playback
  // Note: ensure 'audioplayers' is imported
  // import 'package:audioplayers/audioplayers.dart'; (Will add via separate edit if needed, or assume top level import)
  // Actually, I need to add the import to the top of the file first.
  // I will assume I can add the import in a separate block or relying on the user to fix if I miss it,
  // but better to add it.
  // The tool only allows contiguous edits. I will do the class implementation first.

  late final AudioPlayer _audioPlayer;
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;

  final List<Map<String, String>> _sessions = [
    {
      'title': 'Morning Clarity',
      'duration': '5 min',
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', // Placeholder URL
      'color': '0xFFFFAB91', // Colors.orangeAccent[200]
    },
    {
      'title': 'Deep Relaxation',
      'duration': '10 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'color': '0xFF90CAF9', // Colors.blueAccent[200]
    },
    {
      'title': 'Focus Boost',
      'duration': '15 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'color': '0xFFE1BEE7', // Colors.purpleAccent[200]
    },
    {
      'title': 'Sleep Well',
      'duration': '20 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'color': '0xFFC5CAE9', // Colors.indigoAccent[200]
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _currentlyPlayingUrl = null;
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSession(String url) async {
    if (_currentlyPlayingUrl == url && _isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.stop(); // Stop previous
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentlyPlayingUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final url = session['url']!;
        final isMessagePlaying = _currentlyPlayingUrl == url && _isPlaying;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: session['color'] != null
                  ? Color(int.parse(session['color']!))
                  : Colors.blue,
              child: Icon(
                isMessagePlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            title: Text(
              session['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(session['duration']!),
            trailing: isMessagePlaying
                ? const Icon(Icons.graphic_eq, color: Colors.blue)
                : const Icon(Icons.headphones),
            onTap: () => _playSession(url),
          ),
        );
      },
    );
  }
}
