import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_constants.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/account/presentation/account_screen.dart';
import 'features/onboarding/presentation/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/gamification/presentation/widgets/gamification_overlay.dart';

/// The root widget of the application.
///
/// Configures the [MaterialApp] with the custom theme, routing via [GoRouter],
/// and global providers.
class ArtOfEvolveApp extends ConsumerWidget {
  const ArtOfEvolveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProvider);

    final router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isOnboarding = state.matchedLocation == '/onboarding';

        if (userProfile == null || !userProfile.hasCompletedOnboarding) {
          return '/onboarding';
        }

        if (isOnboarding && userProfile.hasCompletedOnboarding) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GamificationOverlay(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
