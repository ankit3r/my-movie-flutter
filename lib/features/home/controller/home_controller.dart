// lib/features/home/controller/home_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/enums/movie_category.dart';
import '../../../data/models/movie_model.dart';
import '../../../service/tmdb_service.dart';
import '../screens/movies_list_screen.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>();

  final TmdbService _tmdbService = Get.find<TmdbService>();

  // Movie lists
  final RxList<Movie> trendingMovies = <Movie>[].obs;
  final RxList<Movie> nowPlayingMovies = <Movie>[].obs;
  final RxList<Movie> popularMovies = <Movie>[].obs;
  final RxList<Movie> topRatedMovies = <Movie>[].obs;
  final RxList<Movie> upcomingMovies = <Movie>[].obs;

  // Loading states
  final RxBool isLoadingTrending = false.obs;
  final RxBool isLoadingNowPlaying = false.obs;
  final RxBool isLoadingPopular = false.obs;
  final RxBool isLoadingTopRated = false.obs;
  final RxBool isLoadingUpcoming = false.obs;

  // Page tracking
  final RxInt trendingPage = 1.obs;
  final RxInt nowPlayingPage = 1.obs;
  final RxInt popularPage = 1.obs;
  final RxInt topRatedPage = 1.obs;
  final RxInt upcomingPage = 1.obs;

  // Total pages tracking
  final RxInt trendingTotalPages = 1.obs;
  final RxInt nowPlayingTotalPages = 1.obs;
  final RxInt popularTotalPages = 1.obs;
  final RxInt topRatedTotalPages = 1.obs;
  final RxInt upcomingTotalPages = 1.obs;

  // Retry counters (max 3)
  static const int maxRetry = 3;
  final RxInt trendingRetry = 0.obs;
  final RxInt nowPlayingRetry = 0.obs;
  final RxInt popularRetry = 0.obs;
  final RxInt topRatedRetry = 0.obs;
  final RxInt upcomingRetry = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllMovies();
  }


  /// Load all movie categories safely
  Future<void> loadAllMovies() async {
    // Trending
    try {
      await loadTrendingMovies();
    } catch (_) {}

    // Now Playing
    try {
      await loadNowPlayingMovies();
    } catch (_) {}

    // Popular
    try {
      await loadPopularMovies();
    } catch (_) {}

    // Top Rated
    try {
      await loadTopRatedMovies();
    } catch (_) {}

    // Upcoming
    try {
      await loadUpcomingMovies();
    } catch (_) {}
  }


  /// Refresh all movies (pull to refresh)
  Future<void> refreshAllMovies() async {
    trendingPage.value = 1;
    nowPlayingPage.value = 1;
    popularPage.value = 1;
    topRatedPage.value = 1;
    upcomingPage.value = 1;

    trendingRetry.value = 0;
    nowPlayingRetry.value = 0;
    popularRetry.value = 0;
    topRatedRetry.value = 0;
    upcomingRetry.value = 0;

    await loadAllMovies();
  }

  /// Load trending movies with retry counter
  Future<void> loadTrendingMovies({bool loadMore = false}) async {
    if (isLoadingTrending.value) return;

    try {
      if (loadMore) {
        if (!hasMorePages('trending')) return;
        trendingPage.value++;
      } else {
        isLoadingTrending.value = true;
        trendingPage.value = 1;
        trendingMovies.clear();
      }

      final response = await _tmdbService.getTrendingMovies(
        page: trendingPage.value,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        trendingTotalPages.value = response['total_pages'] as int;
        if (trendingPage.value == 1) {
          trendingMovies.value = movies;
        } else {
          trendingMovies.addAll(movies);
        }
        trendingRetry.value = 0; // success
      } else {
        trendingRetry.value++;
      }
    } catch (e) {
      trendingRetry.value++;
      debugPrint('Error loading trending movies: $e');
      _showErrorSnackbar('Failed to load trending movies');
    } finally {
      isLoadingTrending.value = false;
    }
  }

  /// Load now playing movies with retry counter
  Future<void> loadNowPlayingMovies({bool loadMore = false}) async {
    if (isLoadingNowPlaying.value) return;

    try {
      if (loadMore) {
        if (!hasMorePages('nowPlaying')) return;
        nowPlayingPage.value++;
      } else {
        isLoadingNowPlaying.value = true;
        nowPlayingPage.value = 1;
        nowPlayingMovies.clear();
      }

      final response = await _tmdbService.getNowPlayingMovies(
        page: nowPlayingPage.value,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        nowPlayingTotalPages.value = response['total_pages'] as int;
        if (nowPlayingPage.value == 1) {
          nowPlayingMovies.value = movies;
        } else {
          nowPlayingMovies.addAll(movies);
        }
        nowPlayingRetry.value = 0;
      } else {
        nowPlayingRetry.value++;
      }
    } catch (e) {
      nowPlayingRetry.value++;
      debugPrint('Error loading now playing movies: $e');
      _showErrorSnackbar('Failed to load now playing movies');
    } finally {
      isLoadingNowPlaying.value = false;
    }
  }

  /// Load popular movies with retry counter
  Future<void> loadPopularMovies({bool loadMore = false}) async {
    if (isLoadingPopular.value) return;

    try {
      if (loadMore) {
        if (!hasMorePages('popular')) return;
        popularPage.value++;
      } else {
        isLoadingPopular.value = true;
        popularPage.value = 1;
        popularMovies.clear();
      }

      final response = await _tmdbService.getPopularMovies(
        page: popularPage.value,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        popularTotalPages.value = response['total_pages'] as int;
        if (popularPage.value == 1) {
          popularMovies.value = movies;
        } else {
          popularMovies.addAll(movies);
        }
        popularRetry.value = 0;
      } else {
        popularRetry.value++;
      }
    } catch (e) {
      popularRetry.value++;
      debugPrint('Error loading popular movies: $e');
      _showErrorSnackbar('Failed to load popular movies');
    } finally {
      isLoadingPopular.value = false;
    }
  }

  /// Load top rated movies with retry counter
  Future<void> loadTopRatedMovies({bool loadMore = false}) async {
    if (isLoadingTopRated.value) return;

    try {
      if (loadMore) {
        if (!hasMorePages('topRated')) return;
        topRatedPage.value++;
      } else {
        isLoadingTopRated.value = true;
        topRatedPage.value = 1;
        topRatedMovies.clear();
      }

      final response = await _tmdbService.getTopRatedMovies(
        page: topRatedPage.value,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        topRatedTotalPages.value = response['total_pages'] as int;
        if (topRatedPage.value == 1) {
          topRatedMovies.value = movies;
        } else {
          topRatedMovies.addAll(movies);
        }
        topRatedRetry.value = 0;
      } else {
        topRatedRetry.value++;
      }
    } catch (e) {
      topRatedRetry.value++;
      debugPrint('Error loading top rated movies: $e');
      _showErrorSnackbar('Failed to load top rated movies');
    } finally {
      isLoadingTopRated.value = false;
    }
  }

  /// Load upcoming movies with retry counter
  Future<void> loadUpcomingMovies({bool loadMore = false}) async {
    if (isLoadingUpcoming.value) return;

    try {
      if (loadMore) {
        if (!hasMorePages('upcoming')) return;
        upcomingPage.value++;
      } else {
        isLoadingUpcoming.value = true;
        upcomingPage.value = 1;
        upcomingMovies.clear();
      }

      final response = await _tmdbService.getUpcomingMovies(
        page: upcomingPage.value,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        upcomingTotalPages.value = response['total_pages'] as int;
        if (upcomingPage.value == 1) {
          upcomingMovies.value = movies;
        } else {
          upcomingMovies.addAll(movies);
        }
        upcomingRetry.value = 0;
      } else {
        upcomingRetry.value++;
      }
    } catch (e) {
      upcomingRetry.value++;
      debugPrint('Error loading upcoming movies: $e');
      _showErrorSnackbar('Failed to load upcoming movies');
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  /// Navigate to movie details
  void navigateToMovieDetails(int movieId) {
    Get.toNamed('/movie/$movieId');
  }

  /// Navigate to full list screen
  void navigateToMoviesList({
    MovieCategory? category,
    int? genreId,
    required String title,
    IconData icon = Icons.movie,
  }) {
    Get.to(
          () => MoviesListScreen(
        category: category,
        genreId: genreId,
        title: title,
        icon: icon,
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Check if more pages are available for a category
  bool hasMorePages(String category) {
    switch (category) {
      case 'trending':
        return trendingPage.value < trendingTotalPages.value;
      case 'nowPlaying':
        return nowPlayingPage.value < nowPlayingTotalPages.value;
      case 'popular':
        return popularPage.value < popularTotalPages.value;
      case 'topRated':
        return topRatedPage.value < topRatedTotalPages.value;
      case 'upcoming':
        return upcomingPage.value < upcomingTotalPages.value;
      default:
        return false;
    }
  }

  /// Get loading state for a category
  bool isLoading(String category) {
    switch (category) {
      case 'trending':
        return isLoadingTrending.value;
      case 'nowPlaying':
        return isLoadingNowPlaying.value;
      case 'popular':
        return isLoadingPopular.value;
      case 'topRated':
        return isLoadingTopRated.value;
      case 'upcoming':
        return isLoadingUpcoming.value;
      default:
        return false;
    }
  }

  /// Has this section exceeded retry limit?
  bool hasExceededRetry(String category) {
    switch (category) {
      case 'trending':
        return trendingRetry.value >= maxRetry;
      case 'nowPlaying':
        return nowPlayingRetry.value >= maxRetry;
      case 'popular':
        return popularRetry.value >= maxRetry;
      case 'topRated':
        return topRatedRetry.value >= maxRetry;
      case 'upcoming':
        return upcomingRetry.value >= maxRetry;
      default:
        return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
