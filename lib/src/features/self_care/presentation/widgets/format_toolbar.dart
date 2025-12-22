import 'package:flutter/material.dart';

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
          _buildToolItem(context, Icons.text_fields, 'Text', onTextTap),
          _buildToolItem(
            context,
            Icons.check_box_outlined,
            'List',
            onChecklistTap,
          ),
          _buildToolItem(context, Icons.mic_none, 'Voice', onVoiceTap),
          _buildToolItem(context, Icons.brush_outlined, 'Draw', onDrawTap),
          _buildToolItem(context, Icons.image_outlined, 'Image', onImageTap),
        ],
      ),
    );
  }

  Widget _buildToolItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
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
