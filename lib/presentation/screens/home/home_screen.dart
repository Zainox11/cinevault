// lib/presentation/screens/home/home_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/img.jpg',
            fit: BoxFit.cover,
          ),

          // Background Overlay (Opacity set kar di gayi hai)
          Container(
            color: isDark
                ? Colors.black.withValues(alpha: 0.65)  // Dark mode mein zyada black shade taake text clear ho
                : Colors.white.withValues(alpha: 0.15), // Light mode mein shade bohat kam kar diya
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  Text(
                    'CineVault',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                      color: AppColors.primary,
                      fontSize: 40,
                      shadows: const [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black54, // Shadow thori dark ki hai
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                  const SizedBox(height: 8),

                  // Subtitle text fix kar diya gaya hai
                  Text(
                    'Your personal movie universe.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // Dark mode mein bright white aur light mein dark grey
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      shadows: isDark ? const [
                        Shadow(blurRadius: 4.0, color: Colors.black, offset: Offset(0, 1))
                      ] : null,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                  const Spacer(),

                  ..._navItems.asMap().entries.map((entry) {
                    final delay = (entry.key * 100).ms;
                    return _HomeNavTile(item: entry.value)
                        .animate()
                        .fadeIn(delay: 300.ms + delay, duration: 500.ms)
                        .slideX(begin: 0.3);
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.local_fire_department_rounded,
      label: 'Trending Now',
      subtitle: 'This week\'s most popular',
      route: AppRoutes.trending,
      accent: AppColors.primary,
    ),
    _NavItem(
      icon: Icons.bookmark_rounded,
      label: 'My Watchlist',
      subtitle: 'Movies you\'ve saved',
      route: AppRoutes.watchlist,
      accent: Color(0xFF7B61FF),
    ),
    _NavItem(
      icon: Icons.search_rounded,
      label: 'Search Movies',
      subtitle: 'Find any film instantly',
      route: AppRoutes.search,
      accent: Color(0xFF40C8B5),
    ),
    _NavItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      subtitle: 'Preferences & about',
      route: AppRoutes.settings,
      accent: Colors.grey, // Grey color thora clear hota hai glass par
    ),
  ];
}

class _NavItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final String route;
  final Color accent;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.route,
    required this.accent,
  });
}

class _HomeNavTile extends StatelessWidget {
  final _NavItem item;
  const _HomeNavTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(20);

    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // Blur thora aur smooth kiya hai
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                // Glass box ka color aur opacity fix ki hai
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.65),
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.accent, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            )),
                        const SizedBox(height: 2),
                        Text(item.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.white60 : Colors.black54,
                            )),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: isDark ? Colors.white54 : Colors.black38),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}