import 'package:flutter/material.dart';
import 'dashboard_view.dart';
import '../../todos/presentation/todos_screen.dart';
import '../../goals/presentation/goals_screen.dart';
import '../../self_care/presentation/self_care_screen.dart';

/// The main screen of the application.
///
/// It uses a [NavigationBar] to switch between:
/// - Dashboard (Home)
/// - To-Dos
/// - Goals
/// - Self Care
///
/// This screen maintains the state of the selected tab.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const TodosScreen(),
    const GoalsScreen(),
    const SelfCareScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentTabIndex ==
              3 // Self Care has its own appbar logic in the tab controller
          ? null
          : AppBar(title: const Text('My Daily Journey'), centerTitle: true),
      body: IndexedStack(index: _currentTabIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'To-Dos',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'Self Care',
          ),
        ],
      ),
    );
  }
}
