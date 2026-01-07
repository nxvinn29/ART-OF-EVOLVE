/// Represents an achievement badge in the gamification system.
///
/// Badges are earned by completing specific tasks or reaching streaks.
class Badge {
  /// Unique identifier for the badge (e.g. 'first_step').
  final String id;

  /// Display name of the badge.
  final String name;

  /// Description of how to earn the badge.
  final String description;

  /// Path to the asset image for this badge.
  final String assetPath;

  /// Experience points awarded when this badge is unlocked.
  final int xpReward;

  /// Creates a new [Badge] instance.
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.xpReward,
  });

  // Pre-defined Badges
  static const List<Badge> allBadges = [
    Badge(
      id: 'first_step',
      name: 'First Step',
      description: 'Complete your first habit.',
      assetPath: 'assets/images/badges/first_step.png',
      xpReward: 50,
    ),

    /// Awarded for reaching a 3-day streak.
    Badge(
      id: 'streak_3',
      name: 'On Fire',
      description: 'Reach a 3-day streak.',
      assetPath: 'assets/images/badges/fire.png',
      xpReward: 100,
    ),

    /// Awarded for reaching a 7-day streak.
    Badge(
      id: 'streak_7',
      name: 'Unstoppable',
      description: 'Reach a 7-day streak.',
      assetPath: 'assets/images/badges/star.png',
      xpReward: 250,
    ),

    /// Awarded for completing a habit before 8 AM.
    Badge(
      id: 'early_bird',
      name: 'Early Bird',
      description: 'Complete a habit before 8 AM.',
      assetPath: 'assets/images/badges/sun.png',
      xpReward: 150,
    ),
  ];
}
