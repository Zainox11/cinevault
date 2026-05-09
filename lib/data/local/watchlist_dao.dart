// lib/data/local/watchlist_dao.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';
import 'hive_database.dart';

/// Abstracts all CRUD operations for the local watchlist.
/// Returns typed results to keep business logic out of the UI.
class WatchlistDao {
  Box<Movie> get _box => HiveDatabase.watchlistBox;

  /// Fetch all saved movies
  List<Movie> getAllMovies() => _box.values.toList();

  /// Check if a movie is already in the watchlist
  bool isInWatchlist(int movieId) => _box.containsKey(movieId);

  /// Add a movie — uses movie.id as the Hive key for O(1) lookup
  Future<void> addMovie(Movie movie) async {
    await _box.put(movie.id, movie);
  }

  /// Remove a movie by its TMDB ID
  Future<void> removeMovie(int movieId) async {
    await _box.delete(movieId);
  }

  /// Toggle presence in watchlist — returns new state
  Future<bool> toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie.id)) {
      await removeMovie(movie.id);
      return false;
    } else {
      await addMovie(movie);
      return true;
    }
  }

  /// Stream of box changes for reactive UI updates
  Stream<BoxEvent> watchChanges() => _box.watch();
}