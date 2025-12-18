import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  // static const String _appGroupId = 'group.com.example.artofevolve';
  static const String _androidWidgetName =
      'ArtOfEvolveWidget'; // Matches android/app/src/main/res/xml/widget_info.xml

  Future<void> updateDailyProgress(int completedHabits, int totalHabits) async {
    try {
      await HomeWidget.saveWidgetData<int>('completed_habits', completedHabits);
      await HomeWidget.saveWidgetData<int>('total_habits', totalHabits);

      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: 'ArtOfEvolveWidget',
        qualifiedAndroidName:
            'com.example.artofevolve.ArtOfEvolveWidget', // Replace with actual class path
      );
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }
}
