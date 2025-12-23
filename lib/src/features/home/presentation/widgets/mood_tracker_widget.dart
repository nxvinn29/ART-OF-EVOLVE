import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that allows users to select and track their current mood.
///
/// Displays a list of moods with associated colors and icons.
class MoodTrackerWidget extends StatefulWidget {
  const MoodTrackerWidget({super.key});

  @override
  State<MoodTrackerWidget> createState() => _MoodTrackerWidgetState();
}

class _MoodTrackerWidgetState extends State<MoodTrackerWidget> {
  int _selectedMoodIndex = -1;

  final List<Map<String, dynamic>> _moods = [
    {
      'label': 'Happy',
      'color': AppTheme.accentYellow,
      'icon': Icons.sentiment_very_satisfied,
    },
    {'label': 'Calm', 'color': AppTheme.accentGreen, 'icon': Icons.spa},
    {
      'label': 'Sad',
      'color': AppTheme.secondary,
      'icon': Icons.sentiment_dissatisfied,
    },
    {'label': 'Angry', 'color': AppTheme.accentPink, 'icon': Icons.bolt},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = _selectedMoodIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedMoodIndex = index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? mood['color']
                            : mood['color'].withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        mood['icon'],
                        color: isSelected ? Colors.white : Colors.black54,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mood['label'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? mood['color'] : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
