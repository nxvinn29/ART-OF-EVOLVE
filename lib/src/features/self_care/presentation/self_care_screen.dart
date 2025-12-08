import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'journal_controller.dart';
import 'journal_editor_screen.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalControllerProvider);

    return Scaffold(
      body: entriesAsync.when(
        data: (entries) {
          // Filter out Gratitude specific entries to keep Journal clean?
          // Or show all? Let's show non-gratitude or all.
          // For now, let's show everything in Journal, but only Gratitude in Gratitude.
          if (entries.isEmpty) {
            return const Center(child: Text('Write your first journal entry.'));
          }
          return ListView.builder(
            itemCount: entries.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final entry = entries[index];
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
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    title: Text(
                      entry.title.isNotEmpty ? entry.title : 'Untitled',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat.MMMd().format(entry.date),
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (entry.mood.isNotEmpty)
                          Chip(
                            label: Text(
                              entry.mood,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
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

class _MeditationTab extends StatelessWidget {
  const _MeditationTab();

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {
        'title': 'Morning Clariity',
        'duration': '5 min',
        'color': Colors.orangeAccent,
      },
      {
        'title': 'Deep Relaxation',
        'duration': '10 min',
        'color': Colors.blueAccent,
      },
      {
        'title': 'Focus Boost',
        'duration': '15 min',
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Sleep Well',
        'duration': '20 min',
        'color': Colors.indigoAccent,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: session['color'] as Color,
              child: const Icon(Icons.play_arrow, color: Colors.white),
            ),
            title: Text(
              session['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(session['duration'] as String),
            trailing: const Icon(Icons.headphones),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Playing ${session['title']} (Mock)')),
              );
            },
          ),
        );
      },
    );
  }
}
