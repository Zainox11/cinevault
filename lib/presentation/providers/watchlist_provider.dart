// lib/presentation/providers/watchlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/watchlist_dao.dart';
import '../../data/models/movie.dart';

final watchlistDaoProvider = Provider<WatchlistDao>((_) => WatchlistDao());

/// Notifier for full watchlist state management
class WatchlistNotifier extends Notifier<List<Movie>> {
  late final WatchlistDao _dao;

  @override
  List<Movie> build() {
    _dao = ref.read(watchlistDaoProvider);
    return _dao.getAllMovies();
  }

  Future<void> toggleMovie(Movie movie) async {
    await _dao.toggleWatchlist(movie);
    // Rebuild state from source of truth
    state = _dao.getAllMovies();
  }

  bool isInWatchlist(int movieId) => _dao.isInWatchlist(movieId);
}

final watchlistProvider =
NotifierProvider<WatchlistNotifier, List<Movie>>(WatchlistNotifier.new);

/// Helper provider: checks watchlist status for a specific movie
final isInWatchlistProvider = Provider.family<bool, int>((ref, movieId) {
  final notifier = ref.watch(watchlistProvider.notifier);
  // Reactively re-evaluates when watchlist changes
  ref.watch(watchlistProvider);
  return notifier.isInWatchlist(movieId);
});