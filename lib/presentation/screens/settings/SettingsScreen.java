// lib/presentation/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
            title: const Text('About CineVault'),
            subtitle: const Text('Version 1.0.0\nDeveloped by Zain Zahid'),
          ),
          const Divider(color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.api_rounded, color: AppColors.textSecondary),
            title: const Text('Powered by TMDB API'),
            subtitle: const Text('Data and images are provided by The Movie Database.'),
          ),
        ],
      ),
    );
  }
}