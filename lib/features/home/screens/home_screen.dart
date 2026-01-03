// lib/features/home/screens/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mymovie/features/home/widgets/search_widget.dart';
import '../../../data/enums/movie_category.dart';
import '/app_importer.dart';
import 'package:flutter/material.dart' hide CarouselController;
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';
import '../controller/carousel_controller.dart';
import '../../genres/screens/genres_screen.dart';
import '../widgets/movie_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../screens/movies_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final searchController = Get.put(MovieSearchController());
    final carouselController = Get.put(CarouselController());
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: lightRed,
      appBar: _buildAppBar(context, searchController, isWeb),
      body: RefreshIndicator(
        onRefresh: homeController.refreshAllMovies,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Featured Slider (Upcoming Movies)
              Obx(
                    () => _buildFeaturedSlider(
                  homeController: homeController,
                  carouselController: carouselController,
                  movies: homeController.upcomingMovies,
                  isLoading: homeController.isLoadingUpcoming.value,
                ),
              ),

              gapBtwSectionH,

              // Trending Movies
              Obx(
                    () => _buildMovieSection(
                  homeController: homeController,
                  title: '🔥 Trending',
                  movies: homeController.trendingMovies,
                  isLoading: homeController.isLoadingTrending.value,
                ),
              ),

              gapBtwSectionH,

              // Now Playing Movies
              Obx(
                    () => _buildMovieSection(
                  homeController: homeController,
                  title: '🎬 Now Playing',
                  movies: homeController.nowPlayingMovies,
                  isLoading: homeController.isLoadingNowPlaying.value,
                ),
              ),

              gapBtwSectionH,

              // Popular Movies
              Obx(
                    () => _buildMovieSection(
                  homeController: homeController,
                  title: '⭐ Popular',
                  movies: homeController.popularMovies,
                  isLoading: homeController.isLoadingPopular.value,
                ),
              ),

              gapBtwSectionH,

              // Top Rated Movies
              Obx(
                    () => _buildMovieSection(
                  homeController: homeController,
                  title: '🏆 Top Rated',
                  movies: homeController.topRatedMovies,
                  isLoading: homeController.isLoadingTopRated.value,
                ),
              ),

              gapBtwSectionH,
            ],
          ),
        ),
      ),
    );
  }

  // Build featured slider with auto-slide
  Widget _buildFeaturedSlider({
    required HomeController homeController,
    required CarouselController carouselController,
    required List movies,
    required bool isLoading,
  }) {
    if (isLoading && movies.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (movies.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No upcoming movies',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0,
        viewportFraction: 1,
        autoPlay: true,
        pageSnapping: true,
      ),
      items: movies.map((movie) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () => homeController.navigateToMovieDetails(movie.id),
              child: _buildFeaturedSlide(movie, homeController),
            );
          },
        );
      }).toList(),
    );
  }

  // Build individual featured slide
  Widget _buildFeaturedSlide(dynamic movie, HomeController homeController) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: movie.backdropPath != null
              ? 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}'
              : movie.posterUrl ?? '',
          fit: BoxFit.cover,
          memCacheWidth: 1280,
          memCacheHeight: 720,
          maxWidthDiskCache: 1280,
          maxHeightDiskCache: 720,
          placeholder: (context, url) =>
              Container(color: Colors.grey.shade900),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade900,
            child: const Icon(Icons.error, color: Colors.white),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Rating and Release Date
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.releaseDate ?? 'Coming Soon',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Overview
                if (movie.overview != null && movie.overview.isNotEmpty)
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                gapH,

                // Action Buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          homeController.navigateToMovieDetails(movie.id),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch Now'),
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
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          homeController.navigateToMovieDetails(movie.id),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('More Info'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build movie section with horizontal list
  Widget _buildMovieSection({
    required HomeController homeController,
    required String title,
    required List movies,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (movies.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    // Open full list screen based on section title
                    if (title == '🔥 Trending') {
                      Get.to(
                            () => const MoviesListScreen(
                          category: MovieCategory.trending,
                          title: 'Trending Movies',
                          icon: Icons.local_fire_department,
                        ),
                      );
                    } else if (title == '🎬 Now Playing') {
                      Get.to(
                            () => const MoviesListScreen(
                          category: MovieCategory.nowPlaying,
                          title: 'Now Playing Movies',
                          icon: Icons.play_circle_outline,
                        ),
                      );
                    } else if (title == '⭐ Popular') {
                      Get.to(
                            () => const MoviesListScreen(
                          category: MovieCategory.popular,
                          title: 'Popular Movies',
                          icon: Icons.trending_up,
                        ),
                      );
                    } else if (title == '🏆 Top Rated') {
                      Get.to(
                            () => const MoviesListScreen(
                          category: MovieCategory.topRated,
                          title: 'Top Rated Movies',
                          icon: Icons.star,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('More'),
                  style:
                  TextButton.styleFrom(foregroundColor: Colors.white70),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Movie List
        if (isLoading && movies.isEmpty)
          const SizedBox(
            height: 290,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        else if (movies.isEmpty)
          const SizedBox(
            height: 290,
            child: Center(
              child: Text(
                'No movies available',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          )
        else
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: MovieCard(
                      imageUrl: movie.posterUrl ?? '',
                      title: movie.title,
                      width: 180,
                      height: 300,
                      onTap: () =>
                          homeController.navigateToMovieDetails(movie.id),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      MovieSearchController searchController,
      bool isWeb,
      ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: GetBuilder<MovieSearchController>(
        builder: (ctrl) {
          return !isWeb && ctrl.isSearchVisible
              ? _buildMobileSearchAppBar(context, ctrl)
              : _buildDefaultAppBar(context, ctrl, isWeb);
        },
      ),
    );
  }

  Widget _buildDefaultAppBar(
      BuildContext context,
      MovieSearchController searchController,
      bool isWeb,
      ) {
    return AppBar(
      title: const Text(
        appName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: lightRed,
      foregroundColor: Colors.white,
      actions: [
        if (isWeb) ...[
          Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: BuildSearchField(
              searchController: searchController,
              enableAutoFocus: false,
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (!isWeb)
          IconButton(
            onPressed: searchController.showSearch,
            icon: const Icon(Icons.search, size: 33),
            tooltip: 'Search',
          ),
        IconButton(
          onPressed: () {
            Get.to(() => const GenresScreen());
          },
          icon: const Icon(Icons.apps, size: 33),
          tooltip: 'Genres',
        ),
      ],
    );
  }

  Widget _buildMobileSearchAppBar(
      BuildContext context,
      MovieSearchController searchController,
      ) {
    return AppBar(
      backgroundColor: lightRed,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: searchController.hideSearch,
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Close search',
      ),
      title: BuildSearchField(
        searchController: searchController,
        enableAutoFocus: true,
      ),
      actions: [
        GetBuilder<MovieSearchController>(
          builder: (ctrl) => IconButton(
            onPressed: ctrl.clearSearch,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
        ),
      ],
    );
  }
}
