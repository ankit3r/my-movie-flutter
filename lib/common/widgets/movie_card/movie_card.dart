import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mymovie/features/home/controller/movie_card_controller.dart';

import '../../../data/models/movie_model.dart';

class MovieAnimatedCard extends StatelessWidget {
  final Movie movie;
  final String heroTag;
  final VoidCallback? onTap;

  const MovieAnimatedCard({
    super.key,
    required this.movie,
    required this.heroTag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MovieCardController(movie.posterUrl ?? ''),
      tag: heroTag,
    );

    return Obx(
          () => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: controller.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: controller.cardColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? () => Get.toNamed('/movie/${movie.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Poster
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl ?? '',
                      width: 130,
                      height: 180,
                      fit: BoxFit.cover,
                      memCacheWidth: 300,
                      memCacheHeight: 450,
                      placeholder: (_, __) => _posterPlaceholder(),
                      errorWidget: (_, __, ___) => _posterError(),
                    ),
                  ),
                ),

                /// Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: TextStyle(
                            color: controller.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// Release date
                        if (movie.releaseDate?.isNotEmpty ?? false)
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color:
                                controller.textColor.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 500),
                                style: TextStyle(
                                  color:
                                  controller.textColor.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                child: Text(movie.releaseDate!),
                              ),
                            ],
                          ),

                        const SizedBox(height: 8),

                        /// Overview
                        if (movie.overview?.isNotEmpty ?? false)
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 500),
                            style: TextStyle(
                              color:
                              controller.textColor.withOpacity(0.6),
                              fontSize: 13,
                              height: 1.4,
                            ),
                            child: Text(
                              movie.overview!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        const SizedBox(height: 8),

                        /// Rating
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 500),
                              style: TextStyle(
                                color: controller.textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              child: Text(
                                movie.voteAverage.toStringAsFixed(1),
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (movie.voteCount != null)
                              AnimatedDefaultTextStyle(
                                duration:
                                const Duration(milliseconds: 500),
                                style: TextStyle(
                                  color:
                                  controller.textColor.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                                child: Text('(${movie.voteCount})'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// Arrow
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 12),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: controller.textColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Poster Placeholder
  Widget _posterPlaceholder() {
    return Container(
      width: 130,
      height: 180,
      color: Colors.grey.shade800,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white54,
        ),
      ),
    );
  }

  /// Poster Error
  Widget _posterError() {
    return Container(
      width: 130,
      height: 180,
      color: Colors.grey.shade800,
      child: const Icon(
        Icons.movie,
        color: Colors.white54,
        size: 40,
      ),
    );
  }
}
