// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'router/app_router.dart';
import 'presentation/providers/theme_provider.dart';

class CineVaultApp extends ConsumerWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Current theme mode ko watch karein
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,

      // Theme switching logic
      themeMode: themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: isDark ? AppColors.background : Colors.grey[50],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        surface: isDark ? AppColors.surface : Colors.white,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: isDark ? AppColors.textPrimary : Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.dmSans(
          color: isDark ? AppColors.textPrimary : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.dmSans(
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
        bodyMedium: GoogleFonts.dmSans(
          color: isDark ? AppColors.textSecondary : Colors.black54,
        ),
        labelSmall: GoogleFonts.dmMono(
          color: isDark ? AppColors.textMuted : Colors.black38,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surface : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.background : Colors.grey[50],
        foregroundColor: isDark ? AppColors.textPrimary : Colors.black87,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.textPrimary : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
      ),
    );
  }
}