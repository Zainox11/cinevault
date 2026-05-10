// lib/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/movie.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/trending/trending_screen.dart';
import '../presentation/screens/detail/movie_detail_screen.dart';
import '../presentation/screens/watchlist/watchlist_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
// Zain: Feedback screen ka import add karein
import '../presentation/screens/feedback/feedback_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/splash';
  static const home = '/';
  static const trending = '/trending';
  static const detail = '/detail/:movieId';
  static const watchlist = '/watchlist';
  static const search = '/search';
  static const settings = '/settings';
  static const feedback = '/feedback'; // Naya Route Name
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.trending,
      builder: (_, __) => const TrendingScreen(),
    ),
    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) {
        final movie = state.extra as Movie;
        final movieId = int.parse(state.pathParameters['movieId']!);
        return MovieDetailScreen(movie: movie, movieId: movieId);
      },
    ),
    GoRoute(
      path: AppRoutes.watchlist,
      builder: (_, __) => const WatchlistScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (_, __) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, __) => const SettingsScreen(),
    ),

    GoRoute(
      path: AppRoutes.feedback,
      builder: (_, __) => const FeedbackScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);