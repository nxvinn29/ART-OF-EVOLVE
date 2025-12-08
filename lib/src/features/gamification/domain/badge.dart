class Badge {
  final String id;
  final String name;
  final String description;
  final String assetPath;
  final int xpReward;

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
    Badge(
      id: 'streak_3',
      name: 'On Fire',
      description: 'Reach a 3-day streak.',
      assetPath: 'assets/images/badges/fire.png',
      xpReward: 100,
    ),
    Badge(
      id: 'streak_7',
      name: 'Unstoppable',
      description: 'Reach a 7-day streak.',
      assetPath: 'assets/images/badges/star.png',
      xpReward: 250,
    ),
    Badge(
      id: 'early_bird',
      name: 'Early Bird',
      description: 'Complete a habit before 8 AM.',
      assetPath: 'assets/images/badges/sun.png',
      xpReward: 150,
    ),
  ];
}
