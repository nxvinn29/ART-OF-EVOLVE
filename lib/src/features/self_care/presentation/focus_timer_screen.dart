import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:art_of_evolve/src/services/notifications/notification_service.dart';

// Simple provider for NotificationService access
final notificationServiceProvider = Provider<INotificationService>((ref) {
  return NotificationService();
});

class FocusTimerScreen extends ConsumerStatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen> {
  static const int _focusDuration = 25 * 60;
  static const int _shortBreakDuration = 5 * 60;
  static const int _longBreakDuration = 15 * 60;

  int _totalDuration = _focusDuration;
  int _remainingTime = _focusDuration;
  bool _isRunning = false;
  Timer? _timer;
  String _currentMode = 'Focus';

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    // Schedule notification for when it ends
    _scheduleCompletionNotification(Duration(seconds: _remainingTime));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    // Cancel notification if paused? Ideally yes, but for simplicity let's leave it
    // or we'd need to track notification ID.
    // For MVP, if we pause, the notification might still fire if we don't cancel it.
    // Let's cancel it.
    ref.read(notificationServiceProvider).cancelNotification(999);
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    ref.read(notificationServiceProvider).cancelNotification(999);
    setState(() {
      _isRunning = false;
      _remainingTime = _totalDuration;
    });
  }

  void _setMode(String mode, int duration) {
    _pauseTimer();
    setState(() {
      _currentMode = mode;
      _totalDuration = duration;
      _remainingTime = duration;
    });
  }

  Future<void> _scheduleCompletionNotification(Duration duration) async {
    await ref
        .read(notificationServiceProvider)
        .scheduleOneOffNotification(
          id: 999,
          title: '$_currentMode Session Complete',
          body: 'Great job! Time to take a break or start a new session.',
          delay: duration,
        );
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTimerComplete() async {
    setState(() {
      _isRunning = false;
      _remainingTime = _totalDuration;
    });

    // Play sound
    try {
      // Using a default system notification sound or a generic url if assets not available
      // For reliability without assets, we'll try a generic short beep url
      await _audioPlayer.play(
        UrlSource('https://actions.google.com/sounds/v1/alarms/beep_short.ogg'),
      );
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }

    // Show Dialog
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Complete! 🎉'),
        content: Text('You finished your $_currentMode session.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_remainingTime / _totalDuration);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mode Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeChip('Focus', _focusDuration),
              const SizedBox(width: 12),
              _buildModeChip('Short Break', _shortBreakDuration),
              const SizedBox(width: 12),
              _buildModeChip('Long Break', _longBreakDuration),
            ],
          ),
          const SizedBox(height: 48),

          // Timer Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _currentMode == 'Focus'
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_remainingTime),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  Text(
                    _isRunning ? 'RUNNING' : 'PAUSED',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _resetTimer,
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                elevation: 0,
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 24),
              FloatingActionButton.large(
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                backgroundColor: _currentMode == 'Focus'
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFF10B981),
                foregroundColor: Colors.white,
                child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, int duration) {
    final isSelected = _currentMode == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _setMode(label, duration),
      selectedColor: const Color(0xFF4F46E5).withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF4F46E5) : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
