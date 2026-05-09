// lib/domain/repositories/movie_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/tmdb_api_service.dart';
import '../../data/models/movie.dart';
import '../../data/models/cast.dart';
import '../../data/models/video.dart';

// 1. API Service ka Provider
final tmdbApiServiceProvider = Provider<TmdbApiService>((ref) {
  return TmdbApiService();
});

// 2. Repository ka Provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiService = ref.watch(tmdbApiServiceProvider);
  return MovieRepository(apiService);
});

// 3. Main Repository Class
class MovieRepository {
  final TmdbApiService _apiService;

  MovieRepository(this._apiService);

  // --- Puranay Functions (Updated names to match TmdbApiService) ---

  Future<List<Movie>> getTrendingMovies() async {
    // Aapki API service mein iska naam 'fetchTrendingMovies' hai
    return await _apiService.fetchTrendingMovies();
  }

  Future<List<Movie>> searchMovies(String query) async {
    // Aapki API service mein iska naam 'searchMovies' hi hai
    return await _apiService.searchMovies(query);
  }

  // --- Naye Functions ---

  Future<List<Cast>> getMovieCast(int movieId) async {
    return await _apiService.getMovieCast(movieId);
  }

  Future<List<Video>> getMovieVideos(int movieId) async {
    return await _apiService.getMovieVideos(movieId);
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    return await _apiService.getSimilarMovies(movieId);
  }
}