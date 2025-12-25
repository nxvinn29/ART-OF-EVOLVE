import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../gamification_controller.dart';

class LevelProgressBar extends ConsumerWidget {
  final bool isDarkBackground;

  const LevelProgressBar({super.key, this.isDarkBackground = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gamificationControllerProvider);
    final xpRequired = stats.level * 100;
    final progress = (stats.currentXp / xpRequired).clamp(0.0, 1.0);

    final textColor = isDarkBackground ? Colors.white : const Color(0xFF2D3142);
    final subTextColor = isDarkBackground ? Colors.white70 : Colors.grey[600];
    final trackColor = isDarkBackground ? Colors.black12 : Colors.grey[200];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level ${stats.level}',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(
              '${stats.currentXp} / $xpRequired XP',
              style: TextStyle(fontSize: 12, color: subTextColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: trackColor,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFFFF8A65),
            ), // Pastel Orange
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
