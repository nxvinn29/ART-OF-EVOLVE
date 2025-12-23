import 'package:flutter/material.dart';

/// A toolbar widget that displays various formatting options.
///
/// This widget provides buttons for:
/// * Inputting Text
/// * Creating Checklists
/// * Voice Recording
/// * Drawing
/// * Adding Images
class FormatToolbar extends StatelessWidget {
  final VoidCallback onTextTap;
  final VoidCallback onChecklistTap;
  final VoidCallback onVoiceTap;
  final VoidCallback onDrawTap;
  final VoidCallback onImageTap;

  const FormatToolbar({
    super.key,
    required this.onTextTap,
    required this.onChecklistTap,
    required this.onVoiceTap,
    required this.onDrawTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ToolbarItem(icon: Icons.text_fields, label: 'Text', onTap: onTextTap),
          ToolbarItem(
            icon: Icons.check_box_outlined,
            label: 'List',
            onTap: onChecklistTap,
          ),
          ToolbarItem(icon: Icons.mic_none, label: 'Voice', onTap: onVoiceTap),
          ToolbarItem(
            icon: Icons.brush_outlined,
            label: 'Draw',
            onTap: onDrawTap,
          ),
          ToolbarItem(
            icon: Icons.image_outlined,
            label: 'Image',
            onTap: onImageTap,
          ),
        ],
      ),
    );
  }
}

class ToolbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
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
