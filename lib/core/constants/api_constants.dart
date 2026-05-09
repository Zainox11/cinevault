// lib/core/constants/api_constants.dart

/// ─────────────────────────────────────────────
///  SETUP INSTRUCTIONS FOR FUTURE DEVELOPERS:
///
///  1. Create a free TMDB account at https://www.themoviedb.org
///  2. Go to Settings → API → Request API Key
///  3. Copy your "API Read Access Token" (Bearer token)
///  4. Store it using flutter_secure_storage or
///     via --dart-define at build time:
///
///     flutter run --dart-define=TMDB_API_KEY=your_key_here
///
///  NEVER commit raw API keys to version control.
/// ─────────────────────────────────────────────

class ApiConstants {
  ApiConstants._(); // Prevent instantiation

  /// Retrieved safely via dart-define at build/CI time
  static const String tmdbApiKey =
  String.fromEnvironment('TMDB_API_KEY', defaultValue: '');

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';

  // Endpoints
  static const String trendingMovies = '/trending/movie/week';
  static const String movieDetails = '/movie'; // append /{movie_id}
  static const String searchMovies = '/search/movie';
  static const String genres = '/genre/movie/list';

  /// Construct full poster URL
  static String posterUrl(String? path) =>
      path != null ? '$imageBaseUrl$path' : '';

  static String backdropUrl(String? path) =>
      path != null ? '$backdropBaseUrl$path' : '';
}