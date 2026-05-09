// lib/data/local/hive_database.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';

/// Central manager for Hive initialization and box access.
///
/// FUTURE DEVELOPERS:
///   Add new boxes here when extending the local schema.
///   Never open raw boxes outside this class to keep
///   database access consistent and easy to mock in tests.
class HiveDatabase {
  HiveDatabase._();

  static const String _watchlistBox = 'watchlist_box';

  /// Must be called in main() before runApp()
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register all Hive type adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter()); // Generated adapter
    }

    // Open all boxes
    await Hive.openBox<Movie>(_watchlistBox);
  }

  /// Returns the open watchlist box
  static Box<Movie> get watchlistBox =>
      Hive.box<Movie>(_watchlistBox);

  /// Graceful cleanup — call on app disposal
  static Future<void> close() async => await Hive.close();
}