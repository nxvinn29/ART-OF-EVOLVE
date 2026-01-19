import 'package:flutter/material.dart';

/// A toolbar item widget with an icon and label.
///
/// Used in [FormatToolbar] to represent a single action or tool.
class ToolbarItem extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The label for the tooltip.
  final String label;

  /// Callback when the item is tapped.
  final VoidCallback onTap;

  const ToolbarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, color: Theme.of(context).primaryColor)],
          ),
        ),
      ),
    );
  }
}
