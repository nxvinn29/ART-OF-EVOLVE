import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/badge.dart' as app_badge;
import '../gamification_controller.dart';

class BadgeShowcaseWidget extends ConsumerWidget {
  const BadgeShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gamificationControllerProvider);
    final unlockedIds = stats.unlockedBadgeIds;

    if (unlockedIds.isEmpty) {
      return const SizedBox.shrink(); // Hide if no badges
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3142),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: unlockedIds.length,
            itemBuilder: (context, index) {
              final badgeId = unlockedIds[index];
              final badge = app_badge.Badge.allBadges.firstWhere(
                (b) => b.id == badgeId,
                orElse: () => const app_badge.Badge(
                  id: 'unknown',
                  name: '???',
                  description: '',
                  assetPath: '',
                  xpReward: 0,
                ),
              );

              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // In a real app, use Image.asset(badge.assetPath)
                      // For now, use an Icon as placeholder if asset missing
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
