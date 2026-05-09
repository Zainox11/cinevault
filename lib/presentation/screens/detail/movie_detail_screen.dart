import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../providers/watchlist_provider.dart';
import '../../providers/movie_detail_provider.dart';
import '../../widgets/movie_card.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final Movie movie;
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.movieId,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  YoutubePlayerController? _controller;

  void setupPlayer(String key) {
    _controller ??= YoutubePlayerController(
      initialVideoId: key,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
      ),
    );
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInWatchlist = ref.watch(isInWatchlistProvider(widget.movie.id));
    final castAsync = ref.watch(movieCastProvider(widget.movie.id));
    final videosAsync = ref.watch(movieVideosProvider(widget.movie.id));
    final similarAsync = ref.watch(similarMoviesProvider(widget.movie.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. YouTube Player or Backdrop Image in SliverAppBar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: videosAsync.when(
                data: (videos) {
                  if (videos.isEmpty) {
                    return CachedNetworkImage(
                      imageUrl: ApiConstants.backdropUrl(widget.movie.backdropPath),
                      fit: BoxFit.cover,
                    );
                  }

                  final trailer = videos.firstWhere(
                        (v) => v.type == 'Trailer',
                    orElse: () => videos.first,
                  );

                  setupPlayer(trailer.key);

                  return YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.primary,
                    ),
                    builder: (context, player) => player,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => CachedNetworkImage(
                  imageUrl: ApiConstants.backdropUrl(widget.movie.backdropPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.movie.title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 12),

                  // Meta Info Row
                  Row(
                    children: [
                      _MetaBadge(
                        icon: Icons.star_rounded,
                        label: widget.movie.formattedRating,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _MetaBadge(
                        icon: Icons.calendar_today_rounded,
                        label: widget.movie.releaseYear,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overview Section
                  Text('Overview', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview ?? 'No overview available.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Watchlist Button (FIXED COLOR & TEXT)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => ref.read(watchlistProvider.notifier).toggleMovie(widget.movie),
                      icon: Icon(isInWatchlist ? Icons.bookmark_remove : Icons.bookmark_add),
                      label: Text(
                        isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInWatchlist ? AppColors.surfaceElevated : AppColors.primary,
                        foregroundColor: isInWatchlist ? Colors.white : Colors.black, // Color Fix
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 2. Cast Section
                  Text('Top Cast', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 125,
                    child: castAsync.when(
                      data: (castList) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: castList.length,
                        itemBuilder: (context, index) {
                          final actor = castList[index];
                          return Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: actor.profilePath != null
                                      ? CachedNetworkImageProvider(ApiConstants.posterUrl(actor.profilePath))
                                      : null,
                                  child: actor.profilePath == null ? const Icon(Icons.person) : null,
                                ),
                                const SizedBox(height: 8),
                                Text(actor.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                                Text(actor.character, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                              ],
                            ),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text("Cast load nahi ho saki"),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. Similar Movies Section (RESTORED & ADDED PAUSE LOGIC)
                  Text('More Like This', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: similarAsync.when(
                      data: (movies) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) => SizedBox(
                          width: 135,
                          child: MovieCard(
                            movie: movies[index],
                            // Jab user nayi movie par click karega toh purani video ruk jayegi
                            onMovieTap: () {
                              _controller?.pause();
                            },
                          ),
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text("Similar movies load nahi huin"),
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
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}