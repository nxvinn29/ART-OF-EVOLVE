import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../gamification_controller.dart';

const _kDarkTextColor = Colors.white;
const _kLightTextColor = Color(0xFF2D3142);
const _kDarkSubTextColor = Colors.white70;
final _kLightSubTextColor = Colors.grey[600];
const _kDarkTrackColor = Colors.black12;
final _kLightTrackColor = Colors.grey[200];
const _kProgressColor = Color(0xFFFF8A65); // Pastel Orange

/// A widget that displays the user's current level and XP progress.
///
/// This widget renders a linear progress indicator wrapped in a [ClipRRect],
/// along with text displaying the current level and XP stats.
class LevelProgressBar extends ConsumerWidget {
  /// Whether to use a dark background color scheme.
  ///
  /// If true, text and background colors are adjusted for visibility on dark surfaces.
  final bool isDarkBackground;

  const LevelProgressBar({super.key, this.isDarkBackground = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the gamification state to update UI on changes
    final stats = ref.watch(gamificationControllerProvider);
    final xpRequired = stats.level * 100;
    final progress = (stats.currentXp / xpRequired).clamp(0.0, 1.0);

    final textColor = isDarkBackground ? _kDarkTextColor : _kLightTextColor;
    final subTextColor = isDarkBackground
        ? _kDarkSubTextColor
        : _kLightSubTextColor;
    final trackColor = isDarkBackground ? _kDarkTrackColor : _kLightTrackColor;

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
            valueColor: const AlwaysStoppedAnimation<Color>(_kProgressColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
