// lib/presentation/screens/watchlist/watchlist_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../providers/watchlist_provider.dart';
import '../../../router/app_router.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Watchlist (${watchlist.length})'),
      ),
      body: watchlist.isEmpty ? _EmptyState() : _WatchlistBody(movies: watchlist),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_outline_rounded,
              size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No movies saved yet',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Browse trending movies and add them here.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.push(AppRoutes.trending),
            child: const Text('Browse Trending'),
          ),
        ],
      ),
    );
  }
}

class _WatchlistBody extends ConsumerWidget {
  final List<Movie> movies;
  const _WatchlistBody({required this.movies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme check kar rahe hain taake light/dark colors sahi apply hon
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Dismissible(
          key: ValueKey(movie.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_rounded, color: AppColors.error),
          ),
          onDismissed: (_) {
            ref.read(watchlistProvider.notifier).toggleMovie(movie);
          },
          child: GestureDetector(
            onTap: () => context.push('/detail/${movie.id}', extra: movie),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Yahan hardcoded AppColors.surface ki jagah auto-theme color laga diya hai
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.divider : Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.posterUrl(movie.posterPath),
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 60,
                        height: 90,
                        color: isDark ? AppColors.shimmerBase : Colors.grey[200],
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(movie.releaseYear,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primary, size: 14),
                            const SizedBox(width: 4),
                            Text(movie.formattedRating,
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Swipe hint
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}