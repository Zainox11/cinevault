// lib/data/remote/tmdb_api_service.dart

import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';

class TmdbApiService {
  final Dio _dio = DioClient.instance;

  /// Fetch this week's trending movies.
  /// Returns a paginated list — pass [page] for pagination support.
  Future<List<Movie>> fetchTrendingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.trendingMovies,
        queryParameters: {'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(message: 'Failed to load trending movies.');
    }
  }

  /// Fetch full details for a single movie.
  /// TMDB detail endpoint returns richer data than the list endpoint.
  Future<Movie> fetchMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.movieDetails}/$movieId',
        queryParameters: {'append_to_response': 'credits,videos'},
      );
      return Movie.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(message: 'Failed to load movie details.');
    }
  }

  /// Search movies by query string.
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchMovies,
        queryParameters: {'query': query, 'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(message: 'Search failed. Please try again.');
    }
  }
}