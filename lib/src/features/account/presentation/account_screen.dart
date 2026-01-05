import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/presentation/user_provider.dart';
import 'trash_screen.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../gamification/presentation/widgets/badge_showcase_widget.dart';
import 'widgets/profile_header.dart';
import 'widgets/auth_section.dart';
import '../../settings/presentation/widgets/theme_toggle_widget.dart';
import '../../statistics/presentation/statistics_screen.dart';

/// A screen that displays user account information and settings.
///
/// Shows profile header, badge showcase, auth status, theme options,
/// statistics access, and general app settings like calendar configurations.
/// A screen that displays user account information and settings.
///
/// Features:
/// - Profile header with user name.
/// - Badge showcase widget.
/// - Authentication status and actions (Login/Logout).
/// - Theme toggle (Light/Dark/System).
/// - Access to Statistics & Insights and Trash.
/// - Calendar configuration options.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final settings = ref.watch(settingsProvider);
    final name = user?.name ?? 'Friend';
    final authState = ref.watch(authProvider); // Watch auth state
    final isLoggedIn = authState.value != null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppTheme.accountGradient,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for gradient
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'SETTINGS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Profile Header
              const SizedBox(height: 10),
              ProfileHeader(name: name),
              const SizedBox(height: 20),

              const BadgeShowcaseWidget(),

              const SizedBox(height: 20),

              // 2. Auth Section (Dynamic)
              AuthSection(isLoggedIn: isLoggedIn),

              const SizedBox(height: 30),

              // 3. Theme Settings
              const ThemeToggleWidget(),

              const SizedBox(height: 20),

              // 4. Statistics
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.bar_chart_rounded,
                  title: 'Statistics & Insights',
                  color: const Color(0xFFB2DFDB), // Light Teal
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 30),

              // 5. Settings Sections
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Journal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.delete_outline,
                  title: 'Trash',
                  color: const Color(0xFFFFCDD2), // Pink
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TrashScreen(),
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Calendar options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.person_outline,
                  title: 'Your Calendar',
                  color: const Color(0xFFE1BEE7), // Light Purple
                ),
                _SettingsItem(
                  icon: Icons.access_time,
                  title: '24 Hour Time',
                  color: const Color(0xFFB2EBF2), // Light Cyan
                  trailing: Switch(
                    value: settings.is24HourTime,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggle24HourTime();
                    },
                    activeThumbColor: const Color(0xFF26C6DA),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Calendar Display',
                  value: settings.dateFormat,
                  color: const Color(0xFFFFCC80), // Light Orange
                ),
                _SettingsItem(
                  icon: Icons.flag_outlined,
                  title: 'Start Day',
                  value: settings.startOfWeek,
                  color: const Color(0xFFC5E1A5), // Light Green
                ),
                _SettingsItem(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Temperature',
                  value: settings.temperatureUnit,
                  color: const Color(0xFFFFF59D), // Light Yellow
                  onTap: () {
                    // Simple toggle for now
                    final newUnit = settings.temperatureUnit == 'C' ? 'F' : 'C';
                    ref
                        .read(settingsProvider.notifier)
                        .setTemperatureUnit(newUnit);
                  },
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9), // Glassmorphism-ish
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6B4EFF,
            ).withValues(alpha: 0.05), // Soft purple shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: Colors.black87, size: 20),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing:
                    item.trailing ??
                    (item.value != null
                        ? Text(
                            item.value!,
                            style: const TextStyle(color: Colors.grey),
                          )
                        : const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          )),
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey.shade100, indent: 70),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final Color color;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    required this.color,
    this.onTap,
  });
}
