import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_screens.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../onboarding/presentation/user_provider.dart';
import 'trash_screen.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../gamification/presentation/widgets/badge_showcase_widget.dart';

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0F7FA), // Very light Cyan
            Color(0xFFF3E5F5), // Very light Purple
            Color(0xFFFFF3E0), // Very light Orange
          ],
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
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFFFCC80), // Peach
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'A',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const Text(
                "Keep evolving!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              const BadgeShowcaseWidget(),

              const SizedBox(height: 20),

              // 2. Auth Section (Dynamic)
              if (!isLoggedIn)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B4EFF).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Join the Community",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign in to save your progress and sync across devices.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D3142),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text("Sign In"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2D3142),
                                side: const BorderSide(
                                  color: Color(0xFF2D3142),
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text("Create Account"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Sign Out"),
                  ),
                ),

              const SizedBox(height: 30),

              // 3. Settings Sections
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Journal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.delete_outline,
                  title: "Trash",
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
                  "Calendar options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.person_outline,
                  title: "Your Calendar",
                  color: const Color(0xFFE1BEE7), // Light Purple
                ),
                _SettingsItem(
                  icon: Icons.access_time,
                  title: "24 Hour Time",
                  color: const Color(0xFFB2EBF2), // Light Cyan
                  trailing: Switch(
                    value: settings.is24HourTime,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggle24HourTime();
                    },
                    activeColor: const Color(0xFF26C6DA),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.calendar_today_outlined,
                  title: "Calendar Display",
                  value: settings.dateFormat,
                  color: const Color(0xFFFFCC80), // Light Orange
                ),
                _SettingsItem(
                  icon: Icons.flag_outlined,
                  title: "Start Day",
                  value: settings.startOfWeek,
                  color: const Color(0xFFC5E1A5), // Light Green
                ),
                _SettingsItem(
                  icon: Icons.wb_sunny_outlined,
                  title: "Temperature",
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
        color: Colors.white.withOpacity(0.9), // Glassmorphism-ish
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6B4EFF,
            ).withOpacity(0.05), // Soft purple shadow
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
