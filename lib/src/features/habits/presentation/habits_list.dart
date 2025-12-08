import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'habits_controller.dart';
import '../../../core/presentation/animated_checkbox.dart';

class HabitsList extends ConsumerWidget {
  final bool isEmbedded;
  final bool isHorizontal;

  const HabitsList({
    super.key,
    this.isEmbedded = false,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) {
          if (isEmbedded) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No habits yet. Add one!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text('No habits yet. Start evolving!')),
          );
        }

        final list = ListView.builder(
          scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
          shrinkWrap: isEmbedded && !isHorizontal,
          physics: isEmbedded && !isHorizontal
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          itemCount: habits.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemBuilder: (context, index) {
            final habit = habits[index];
            final isCompletedToday = habit.isCompletedOn(DateTime.now());

            // Vibrant "Rich Widget" colors
            final List<Color> pastelColors = [
              const Color(0xFF64FFDA), // Bright Mint
              const Color(0xFFFFAB91), // Vibrant Peach
              const Color(0xFF8C9EFF), // Bright Periwinkle
              const Color(0xFFFF8A80), // Bright Red/Pink
              const Color(0xFFCCFF90), // Bright Lime
              const Color(0xFFEA80FC), // Bright Purple
            ];

            final color = isCompletedToday
                ? Colors.grey.shade200
                : pastelColors[index % pastelColors.length];

            final textColor = isCompletedToday
                ? Colors.black38
                : const Color(0xFF2D3142);

            return Container(
              width: isHorizontal ? 160 : null,
              margin: EdgeInsets.only(
                bottom: isHorizontal ? 0 : 12,
                right: isHorizontal ? 12 : 0,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isHorizontal
                  ? InkWell(
                      onTap: () {
                        ref
                            .read(habitsProvider.notifier)
                            .toggleHabitCompletion(habit.id, DateTime.now());
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              IconData(
                                habit.iconCodePoint,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              habit.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                                decoration: isCompletedToday
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${habit.currentStreak} 🔥',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconData(
                            habit.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: textColor,
                        ),
                      ),
                      title: Text(
                        habit.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                          decoration: isCompletedToday
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        isCompletedToday
                            ? 'Completed!'
                            : '${habit.currentStreak} day streak',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: AnimatedCheckbox(
                        value: isCompletedToday,
                        activeColor: Colors.white,
                        checkColor: Colors.black54,
                        onChanged: (val) {
                          ref
                              .read(habitsProvider.notifier)
                              .toggleHabitCompletion(habit.id, DateTime.now());
                        },
                      ),
                    ),
            );
          },
        );

        if (isEmbedded) return list;

        return Scaffold(
          body: list,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddHabitDialog(context, ref),
            label: const Text('New Habit'),
            icon: const Icon(Icons.add),
            backgroundColor: const Color(0xFF2D3142),
            foregroundColor: Colors.white,
          ),
        );
      },
      loading: () => isEmbedded
          ? const Center(child: CircularProgressIndicator())
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => isEmbedded
          ? Center(child: Text('Error: $err'))
          : Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              'New Habit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.alarm, color: Colors.grey),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() => selectedTime = time);
                        }
                      },
                      child: Text(
                        selectedTime == null
                            ? 'Set Reminder'
                            : selectedTime!.format(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    ref
                        .read(habitsProvider.notifier)
                        .addHabit(
                          titleController.text,
                          reminderTime: selectedTime,
                        );
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4EFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}
