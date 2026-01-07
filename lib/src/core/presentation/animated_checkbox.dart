import 'package:flutter/material.dart';

/// A custom checkbox widget with animation.
///
/// Animates the scale and opacity of the check icon when the value changes.
/// Supports custom [activeColor] and [checkColor].
///
/// Typically used in list tiles for habits or tasks.
class AnimatedCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;

  /// Creates an [AnimatedCheckbox].
  ///
  /// - [value]: The current checked state.
  /// - [onChanged]: Callback when the checkbox is tapped.
  /// - [activeColor]: Color of the checkbox when checked.
  /// - [checkColor]: Color of the check icon.
  const AnimatedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.checkColor = Colors.white,
  });

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.value ? widget.activeColor : Colors.grey.shade400,
            width: 2,
          ),
          color: widget.value ? widget.activeColor : Colors.transparent,
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Icon(Icons.check, size: 20, color: widget.checkColor),
          ),
        ),
      ),
    );
  }
}
