// lib/presentation/providers/movie_detail_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/movie.dart';
import '../../data/models/cast.dart';
import '../../data/models/video.dart';
import '../../domain/repositories/movie_repository.dart';

// 1. Cast Provider
final movieCastProvider = FutureProvider.family<List<Cast>, int>((ref, movieId) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovieCast(movieId);
});

// 2. Videos Provider
final movieVideosProvider = FutureProvider.family<List<Video>, int>((ref, movieId) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovieVideos(movieId);
});

// 3. Similar Movies Provider
final similarMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, movieId) {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getSimilarMovies(movieId);
});