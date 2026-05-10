import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../../router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          const Text('Appearance', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark theme'),
            secondary: const Icon(Icons.dark_mode_rounded),
            value: themeMode == ThemeMode.dark,
            activeColor: AppColors.primary,
            onChanged: (isDark) {
              ref.read(themeModeProvider.notifier).state =
              isDark ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const Divider(color: AppColors.divider),

          // Suggestion Section (Requirement: Link to Form Screen)
          const Text('Contributions', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.movie_filter_rounded, color: Colors.amber),
            title: const Text('Suggest a Movie'),
            subtitle: const Text('Missing something? Let us know!'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // AppRouter mein feedback route par jaye ga
              context.push(AppRoutes.feedback);
            },
          ),
          const Divider(color: AppColors.divider),

          // Preferences Section
          const Text('Preferences', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.notifications_active_rounded),
            title: const Text('Notifications'),
            subtitle: const Text('Manage app alerts (Coming Soon)'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications feature is coming soon!')),
              );
            },
          ),
          const Divider(color: AppColors.divider),

          // About Section
          const Text('About', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('About CineVault'),
            subtitle: Text('Version 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.api_rounded),
            title: Text('Data Source'),
            subtitle: Text('Powered by TMDB API'),
          ),
        ],
      ),
    );
  }
}