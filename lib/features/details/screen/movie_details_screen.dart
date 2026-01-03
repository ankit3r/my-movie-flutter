// lib/features/details/screens/movie_details_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../data/models/movie_details_model.dart';
import '/app_importer.dart';
import '../controller/movie_details_controller.dart';
import '../../home/widgets/movie_card.dart';
import '../widgets/trailer_player.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MovieDetailsController());

    return Scaffold(
      backgroundColor: lightRed,
      body: Obx(() {
        // Loading
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        // Error / not found
        if (controller.hasError || controller.movieDetails == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white70,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.isNotEmpty
                        ? controller.errorMessage
                        : 'Failed to load movie details.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Success
        final movie = controller.movieDetails!;
        return CustomScrollView(
          key: const Key('movie_details_scroll'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(movie),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildTitleSection(movie),
                gapBtwSectionH,
                _buildOverviewSection(movie),
                gapBtwSectionH,

                if (controller.cast.isNotEmpty)
                  Container(
                    key: const Key('cast_section'),
                    child: _buildCastSection(controller),
                  ),

                gapBtwSectionH,

                if (movie.videos != null && movie.videos!.isNotEmpty)
                  Container(
                    key: const Key('trailer_section'),
                    child: _buildTrailerSection(movie),
                  ),

                gapBtwSectionH,

                Container(
                  key: const Key('review_section'),
                  child: _buildReviewsSection(movie),
                ),

                gapBtwSectionH,

                if (controller.similarMovies.isNotEmpty)
                  Container(
                    key: const Key('similar_movies_section'),
                    child: _buildSimilarMoviesSection(controller),
                  ),

                const SizedBox(height: 40),
              ]),
            ),
          ],
        );
      }),
    );
  }

  // AppBar with hero image
  Widget _buildAppBar(MovieDetails movie) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: lightRed,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: movie.backdropPath != null
                  ? 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}'
                  : movie.posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                  : '',
              fit: BoxFit.cover,
              memCacheWidth: 1280,
              memCacheHeight: 720,
              placeholder: (context, url) =>
                  Container(color: Colors.grey.shade900),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade900,
                child: const Icon(
                  Icons.movie,
                  size: 80,
                  color: Colors.white54,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    lightRed.withOpacity(0.7),
                    lightRed,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'movie_${movie.id}',
                    child: Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                              : '',
                          fit: BoxFit.cover,
                          memCacheWidth: 500,
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.movie,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '(${movie.releaseDate?.split('-').first ?? 'N/A'})',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(MovieDetails movie) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: darkRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/10',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (movie.runtime != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.runtime} min',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (movie.genres != null && movie.genres!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: movie.genres!.map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    genre.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(MovieDetails movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            movie.overview ?? 'No overview available',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(MovieDetailsController controller) {
    final castList = controller.cast;
    if (castList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            key: const Key('cast_list'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: castList.take(10).length,
            itemBuilder: (context, index) {
              final actor = castList[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildCastCard(actor),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastCard(dynamic actor) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade900,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: actor['profile_path'] != null
                  ? CachedNetworkImage(
                imageUrl:
                'https://image.tmdb.org/t/p/w185${actor['profile_path']}',
                fit: BoxFit.cover,
                memCacheWidth: 185,
                errorWidget: (context, url, error) =>
                const Icon(Icons.person,
                    size: 40, color: Colors.white54),
              )
                  : const Icon(Icons.person,
                  size: 40, color: Colors.white54),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Text(
              actor['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerSection(MovieDetails movie) {
    if (movie.videos == null || movie.videos!.isEmpty) {
      return const SizedBox.shrink();
    }

    final trailerData = movie.videos!.firstWhere(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
      orElse: () => movie.videos!.isNotEmpty ? movie.videos!.first : null,
    );

    if (trailerData == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Trailer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showTrailerDialog(trailerData['key']),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                    'https://img.youtube.com/vi/${trailerData['key']}/maxresdefault.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    memCacheHeight: 200,
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade900,
                      child: const Icon(
                        Icons.play_circle_outline,
                        size: 60,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
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

  void _showTrailerDialog(String videoKey) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: TrailerPlayer(videoKey: videoKey),
      ),
      barrierDismissible: true,
    );
  }

  /// Reviews section with CarouselSlider; uses movie.reviews
  Widget _buildReviewsSection(MovieDetails movie) {
    final reviews = movie.reviews ?? [];

    // No API reviews -> fallback card using overview
    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'mooney240',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)}/10',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.overview != null &&
                        movie.overview!.length > 100
                        ? movie.overview!.substring(0, 100)
                        : movie.overview ?? 'Great movie!',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.releaseDate ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

// Has reviews -> carousel
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220, // fixed height for card + scroll area
            child: CarouselSlider.builder(
              itemCount: reviews.length,
              options: CarouselOptions(
                height: 220,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enableInfiniteScroll: reviews.length > 1,
              ),
              itemBuilder: (context, index, realIndex) {
                final review = reviews[index];
                final author = review['author'] ?? 'Anonymous';
                final createdAt = review['created_at'] ?? '';
                final content = review['content'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (author + date)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              author,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (createdAt.isNotEmpty)
                            Text(
                              createdAt.split('T').first,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Scrollable review text
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              content,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildSimilarMoviesSection(MovieDetailsController controller) {
    if (controller.similarMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Similar Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 290,
          child: ListView.builder(
            key: const Key('similar_movies_list'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.similarMovies.length,
            itemBuilder: (context, index) {
              final movie = controller.similarMovies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: MovieCard(
                  imageUrl: movie.posterUrl ?? '',
                  title: movie.title,
                  width: 180,
                  height: 300,
                  onTap: () =>
                      controller.navigateToMovieDetails(movie.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
