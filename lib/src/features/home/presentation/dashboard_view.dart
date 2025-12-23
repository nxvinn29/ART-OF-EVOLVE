import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../habits/presentation/habits_list.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/mood_tracker_widget.dart';
import 'widgets/water_tracker_widget.dart';
import 'widgets/mini_todo_list_widget.dart';
import 'widgets/self_care_widget.dart'; // Added SelfCareWidget import

/// The main dashboard view of the application.
///
/// Displays the [MoodTrackerWidget], [WaterTrackerWidget], [MiniTodoListWidget],
/// [SelfCareWidget], and [HabitsList].
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Added Container for gradient background
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppTheme.accountGradient,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for gradient
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SafeArea(
                // Wrapped DashboardHeader in SafeArea
                child: DashboardHeader(),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: const MoodTrackerWidget(),
              ),
              const SizedBox(height: 10),

              // 3. Water Tracker
              const WaterTrackerWidget(),

              // 4. Mini Todo List
              const MiniTodoListWidget(),

              // 5. Self Care Widget (New)
              const SelfCareWidget(),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      "Today's Habits",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 6. Habits List (Horizontal Timeline)
              const SizedBox(
                height: 160,
                child: HabitsList(isEmbedded: true, isHorizontal: true),
              ),
              const SizedBox(height: 80), // Bottom padding for nav bar logic
            ],
          ),
        ),
      ),
    );
  }
}
