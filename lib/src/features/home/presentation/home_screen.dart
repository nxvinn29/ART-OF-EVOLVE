import 'package:flutter/material.dart';
import 'dashboard_view.dart';
import '../../todos/presentation/todos_screen.dart';
import '../../goals/presentation/goals_screen.dart';
import '../../self_care/presentation/self_care_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardView(),
    TodosScreen(),
    GoalsScreen(),
    SelfCareScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentIndex ==
              3 // Self Care has its own appbar logic in the tab controller
          ? null
          : AppBar(title: const Text('My Daily Journey'), centerTitle: true),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
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
