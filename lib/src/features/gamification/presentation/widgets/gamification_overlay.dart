import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../gamification_controller.dart';
import 'dart:math';

class GamificationOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const GamificationOverlay({super.key, required this.child});

  @override
  ConsumerState<GamificationOverlay> createState() =>
      _GamificationOverlayState();
}

class _GamificationOverlayState extends ConsumerState<GamificationOverlay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gamificationControllerProvider, (prev, next) {
      if (prev == null) return;

      // Check for Level Up
      if (next.level > prev.level) {
        _playConfetti();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Level Up! You are now level ${next.level}!'),
            backgroundColor: Colors.purpleAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Check for Badge Unlock
      if (next.unlockedBadgeIds.length > prev.unlockedBadgeIds.length) {
        _playConfetti();
        // Identify which badge was unlocked
        final newBadgeId =
            next.unlockedBadgeIds.last; // Simple assumption for now
        // In a real app we'd diff the sets to find exactly which one
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Badge Unlocked! Keep it up!'),
            backgroundColor: Colors.amber,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Check for XP Gain (only if not leveling up, to avoid spam)
      if (next.currentXp > prev.currentXp && next.level == prev.level) {
        final diff = next.currentXp - prev.currentXp;
        // Don't show for very small amounts if desired, but 10 is standard
        if (diff > 0) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('+$diff XP! Great job!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
