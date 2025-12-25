import 'package:art_of_evolve/src/core/constants/app_constants.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/widgets/toolbar_item.dart';
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
          ToolbarItem(
            icon: Icons.text_fields,
            label: AppConstants.toolbarText,
            onTap: onTextTap,
          ),
          ToolbarItem(
            icon: Icons.check_box_outlined,
            label: AppConstants.toolbarList,
            onTap: onChecklistTap,
          ),
          ToolbarItem(
            icon: Icons.mic_none,
            label: AppConstants.toolbarVoice,
            onTap: onVoiceTap,
          ),
          ToolbarItem(
            icon: Icons.brush_outlined,
            label: AppConstants.toolbarDraw,
            onTap: onDrawTap,
          ),
          ToolbarItem(
            icon: Icons.image_outlined,
            label: AppConstants.toolbarImage,
            onTap: onImageTap,
          ),
        ],
      ),
    );
  }
}
