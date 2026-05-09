// lib/presentation/screens/detail/movie_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../providers/watchlist_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  final Movie movie;
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInWatchlist = ref.watch(isInWatchlistProvider(movie.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible backdrop header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: ApiConstants.backdropUrl(movie.backdropPath),
                    fit: BoxFit.cover,
                  ),
                  // Gradient fade to background
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withOpacity(0.8),
                          AppColors.background,
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 12),

                  // Meta row
                  Row(
                    children: [
                      _MetaBadge(
                        icon: Icons.star_rounded,
                        label: movie.formattedRating,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _MetaBadge(
                        icon: Icons.calendar_today_rounded,
                        label: movie.releaseYear,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      _MetaBadge(
                        icon: Icons.people_rounded,
                        label: '${movie.voteCount} votes',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overview
                  Text('Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview ?? 'No overview available.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Watchlist CTA
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ref
                            .read(watchlistProvider.notifier)
                            .toggleMovie(movie);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isInWatchlist
                                    ? 'Removed from Watchlist'
                                    : 'Added to Watchlist!',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        isInWatchlist
                            ? Icons.bookmark_remove_rounded
                            : Icons.bookmark_add_rounded,
                      ),
                      label: Text(
                        isInWatchlist
                            ? 'Remove from Watchlist'
                            : 'Add to Watchlist',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInWatchlist
                            ? AppColors.surfaceElevated
                            : AppColors.primary,
                        foregroundColor: isInWatchlist
                            ? AppColors.textPrimary
                            : AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}