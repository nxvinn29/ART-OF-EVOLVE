import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../todos/presentation/todos_controller.dart';

class MiniTodoListWidget extends ConsumerWidget {
  const MiniTodoListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(activeTodosProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 220, // Fixed height for the widget
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPaperPainter(
                color: Colors.blueGrey.withOpacity(0.1),
                spacing: 24.0,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'To-Do List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: todosAsync.when(
                    data: (todos) {
                      final pending = todos
                          .where((t) => !t.isCompleted)
                          .take(4)
                          .toList();
                      if (pending.isEmpty) {
                        return const Center(
                          child: Text(
                            'All caught up! 🎉',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: pending
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildRichTodoItem(
                                entry.value,
                                entry.key,
                                ref,
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => const Center(
                      child: Text(
                        'Failed to load tasks',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTodoItem(dynamic todo, int index, WidgetRef ref) {
    // Vibrant highlighter colors
    final List<Color> highlighterColors = [
      const Color(0xFFFF80AB).withOpacity(0.3), // Pink
      const Color(0xFF80D8FF).withOpacity(0.3), // Blue
      const Color(0xFFFFEA00).withOpacity(0.3), // Yellow
      const Color(0xFFB9F6CA).withOpacity(0.3), // Green
    ];

    final highlightColor = highlighterColors[index % highlighterColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Custom Checkbox
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          // Highlighted Text
          Expanded(
            child: Stack(
              children: [
                // Highlight Marker background
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  height: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: highlightColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Text
                Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700, // Bold for marker look
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Delete Button (Soft Delete)
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              ref.read(todosProvider.notifier).deleteTodo(todo.id);
            },
          ),
        ],
      ),
    );
  }
}

class GridPaperPainter extends CustomPainter {
  final Color color;
  final double spacing;

  GridPaperPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw VERTICAL lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw HORIZONTAL lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
