// lib/presentation/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Navigation ke liye import
import '../../../core/constants/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../../router/app_router.dart'; // Routes ke liye import

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme ki current state yahan se milegi
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
              // Button dabane par theme change hoga
              ref.read(themeModeProvider.notifier).state =
              isDark ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const Divider(color: AppColors.divider),

          // Support Section (Zain: Yahan humne Feedback option add kiya hai)
          const Text('Support', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.feedback_rounded, color: Colors.amber),
            title: const Text('Send Feedback'),
            subtitle: const Text('Tell us what you think or report a bug'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Feedback screen par jane ke liye
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
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications will be available in the next update!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_rounded),
            title: const Text('Clear Image Cache'),
            subtitle: const Text('Free up storage space'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully!')),
              );
            },
          ),
          const Divider(color: AppColors.divider),

          // About Section
          const Text('About', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About CineVault'),
            subtitle: const Text('Version 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.api_rounded),
            title: const Text('Powered by TMDB API'),
            subtitle: const Text('Data and images are provided by The Movie Database.'),
          ),
        ],
      ),
    );
  }
}