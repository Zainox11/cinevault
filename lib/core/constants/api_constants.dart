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

// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  // Zain: Maine niche line fix kar di hai.
  // Semicolon aur purani line mita kar sirf direct key rakh di hai.
  static const String tmdbApiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NTA3MjQwYjEwZjJjYTU3NmQ0ODU4ZmMxMjMxM2I4YiIsIm5iZiI6MTc3ODI2MTMzNC45OTQsInN1YiI6IjY5ZmUxZDU2Y2MxMzM3YWYyYjA3NmMzOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZfzeROzPGBL2_vSsmnbU6OKsqHu-47tRa27gKOs3v-8';

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';

  // Endpoints
  static const String trendingMovies = '/trending/movie/week';
  static const String movieDetails = '/movie';
  static const String searchMovies = '/search/movie';
  static const String genres = '/genre/movie/list';

  static String posterUrl(String? path) =>
      path != null ? '$imageBaseUrl$path' : '';

  static String backdropUrl(String? path) =>
      path != null ? '$backdropBaseUrl$path' : '';
}