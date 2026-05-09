// lib/presentation/widgets/movie_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../screens/detail/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onMovieTap; // Naya variable add kiya hai

  const MovieCard({super.key, required this.movie, this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 1. Agar koi action (jaise video pause) pass hua hai, toh usay chalao
        if (onMovieTap != null) {
          onMovieTap!();
        }

        // 2. Phir nayi screen par jao
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movie: movie,
              movieId: movie.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Movie Poster
              CachedNetworkImage(
                imageUrl: ApiConstants.posterUrl(movie.posterPath),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceElevated,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceElevated,
                  child: const Icon(Icons.movie, color: Colors.grey),
                ),
              ),
              // Rating Badge (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}