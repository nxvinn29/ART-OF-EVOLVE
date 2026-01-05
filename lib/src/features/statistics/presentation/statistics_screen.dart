import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../gamification/presentation/gamification_controller.dart';
import '../../gamification/domain/user_stats.dart';
import '../../habits/presentation/habits_controller.dart';
import '../../habits/domain/habit.dart';

/// Statistics and insights screen showing user progress and analytics
/// Statistics and insights screen showing user progress and analytics.
///
/// Displays:
/// - XP and Level overview with progress bar.
/// - Habits completion summary (Total, Today, Rate).
/// - Unlocked achievements/badges.
/// - Weekly progress chart (simulated).
/// - Streak statistics (Longest, Active).
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStats = ref.watch(gamificationControllerProvider);
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('📊 Statistics & Insights')),
      body: habitsAsync.when(
        data: (habits) => _buildContent(context, userStats, habits),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UserStats userStats,
    List<Habit> habits,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // XP & Level Overview
          _buildXPOverviewCard(context, userStats),
          const SizedBox(height: 16),

          // Habits Summary
          _buildHabitsSummaryCard(context, habits),
          const SizedBox(height: 16),

          // Achievements
          _buildAchievementsCard(context, userStats),
          const SizedBox(height: 16),

          // Weekly Progress
          _buildWeeklyProgressCard(context, habits),
          const SizedBox(height: 16),

          // Streaks
          _buildStreaksCard(context, habits),
        ],
      ),
    );
  }

  Widget _buildXPOverviewCard(BuildContext context, UserStats stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final xpRequired = stats.level * 100;
    final progress = stats.currentXp / xpRequired;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🎯 Level ${stats.level}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkPrimary : AppTheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.darkPrimary : AppTheme.primary)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${stats.currentXp} XP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkPrimary : AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor:
                    (isDark ? AppTheme.darkPrimary : AppTheme.primary)
                        .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(
                  isDark ? AppTheme.darkPrimary : AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}% to Level ${stats.level + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsSummaryCard(BuildContext context, List<Habit> habits) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalHabits = habits.length;
    final completedToday = habits
        .where((h) => h.isCompletedOn(DateTime.now()))
        .length;
    final completionRate = totalHabits > 0 ? completedToday / totalHabits : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✅ Habits Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total',
                  totalHabits.toString(),
                  isDark ? AppTheme.darkPrimary : AppTheme.primary,
                ),
                _buildStatItem(
                  context,
                  'Today',
                  completedToday.toString(),
                  isDark ? AppTheme.darkSecondary : AppTheme.secondary,
                ),
                _buildStatItem(
                  context,
                  'Rate',
                  '${(completionRate * 100).toStringAsFixed(0)}%',
                  isDark ? AppTheme.darkTertiary : AppTheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAchievementsCard(BuildContext context, UserStats stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeIds = stats.unlockedBadgeIds;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🏆 Achievements',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (badgeIds.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Complete habits to unlock badges!',
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: badgeIds.map((badgeId) {
                  final badgeName = badgeId == 'first_step'
                      ? 'First Step'
                      : badgeId;
                  final badgeIcon = badgeId == 'first_step' ? '🎯' : '🏆';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.darkPrimary : AppTheme.primary)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(badgeIcon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          badgeName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressCard(BuildContext context, List<Habit> habits) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Weekly Progress',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  // Simulated data - in real app, calculate from actual habit data
                  final height = (50 + (index * 10) % 70).toDouble();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              isDark ? AppTheme.darkPrimary : AppTheme.primary,
                              (isDark
                                      ? AppTheme.darkSecondary
                                      : AppTheme.secondary)
                                  .withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreaksCard(BuildContext context, List<Habit> habits) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
    final activeStreaks = habits.where((h) => h.currentStreak > 0).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔥 Streaks',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStreakStat(
                  context,
                  'Longest',
                  maxStreak.toString(),
                  '🏅',
                  isDark,
                ),
                _buildStreakStat(
                  context,
                  'Active',
                  activeStreaks.toString(),
                  '⚡',
                  isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStat(
    BuildContext context,
    String label,
    String value,
    String emoji,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.darkPrimary : AppTheme.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkPrimary : AppTheme.primary,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
