// lib/presentation/providers/trending_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/movie.dart';
import '../../data/remote/tmdb_api_service.dart';

/// Singleton service provider
final tmdbServiceProvider = Provider<TmdbApiService>(
      (_) => TmdbApiService(),
);

/// Async provider for trending movies — auto-caches and refreshes
final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(tmdbServiceProvider);
  return service.fetchTrendingMovies();
});

/// Family provider — fetches details for a specific movie ID
final movieDetailProvider =
FutureProvider.family<Movie, int>((ref, movieId) async {
  final service = ref.watch(tmdbServiceProvider);
  return service.fetchMovieDetails(movieId);
});

/// Search query state
final searchQueryProvider = StateProvider<String>((_) => '');

/// Derived search results provider
final searchResultsProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final service = ref.watch(tmdbServiceProvider);
  return service.searchMovies(query);
});