// lib/presentation/screens/trending/trending_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../../router/app_router.dart';
import '../../providers/trending_provider.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/error_widget.dart';

class TrendingScreen extends ConsumerWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending This Week'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: trendingAsync.when(
        loading: () => const ShimmerMovieGrid(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(trendingMoviesProvider),
        ),
        data: (movies) => _MovieGrid(movies: movies),
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => _MovieCard(movie: movies[index]),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/detail/${movie.id}',
        extra: movie,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: ApiConstants.posterUrl(movie.posterPath),
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.movie_rounded,
                      color: AppColors.textMuted, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          // Rating & Year
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.primary, size: 14),
              const SizedBox(width: 4),
              Text(movie.formattedRating,
                  style: Theme.of(context).textTheme.labelSmall),
              const Spacer(),
              Text(movie.releaseYear,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}