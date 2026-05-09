// lib/presentation/screens/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../providers/trending_provider.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/error_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    // Theme check kar raha hai taake colors auto-adjust hon
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          // Text color ab theme ke hisaab se khud change hoga (Light me black, Dark me white)
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: isDark ? AppColors.textMuted : Colors.black54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
      body: query.trim().isEmpty
          ? Center(
        child: Text('Type to start searching...',
            style: Theme.of(context).textTheme.bodyMedium),
      )
          : searchResultsAsync.when(
        loading: () => const ShimmerMovieGrid(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(searchResultsProvider),
        ),
        data: (movies) {
          if (movies.isEmpty) {
            return Center(
              child: Text('No movies found for "$query"',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => context.push('/detail/${movie.id}', extra: movie),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // Background color aur border theme ke hisaab se auto-set
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.divider : Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}