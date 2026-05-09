// lib/data/remote/tmdb_api_service.dart

import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/video.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';

class TmdbApiService {
  // Aapka existing Dio instance
  final Dio _dio = DioClient.instance;

  /// Fetch this week's trending movies.
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

  /// Naye functions - Updated with correct Dio instance (_dio)

  Future<List<Cast>> getMovieCast(int movieId) async {
    try {
      final response = await _dio.get('${ApiConstants.movieDetails}/$movieId/credits');
      // Dio mein data access karne ke liye .data['cast'] zaroori hai
      final results = response.data['cast'] as List;
      return results.map((json) => Cast.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load cast: $e');
    }
  }

  Future<List<Video>> getMovieVideos(int movieId) async {
    try {
      final response = await _dio.get('${ApiConstants.movieDetails}/$movieId/videos');
      final results = response.data['results'] as List;
      return results.map((json) => Video.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load videos: $e');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      final response = await _dio.get('${ApiConstants.movieDetails}/$movieId/similar');
      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load similar movies: $e');
    }
  }
}