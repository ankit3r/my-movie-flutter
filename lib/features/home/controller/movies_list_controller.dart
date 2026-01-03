// lib/features/home/controller/movies_list_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/enums/movie_category.dart';
import '../../../service/tmdb_service.dart';

class MoviesListController extends GetxController {
  final TmdbService _tmdbService = Get.find<TmdbService>();

  // Parameters
  MovieCategory? category;
  int? genreId;
  String title = '';

  // State variables
  final _movies = <Movie>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _totalResults = 0.obs;
  final _hasMore = true.obs;
  final _errorMessage = ''.obs;

  // Getters
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalResults => _totalResults.value;
  bool get hasMore => _hasMore.value;
  String get errorMessage => _errorMessage.value;

  /// Initialize controller with parameters
  void init({
    MovieCategory? category,
    int? genreId,
    required String title,
  }) {
    this.category = category;
    this.genreId = genreId;
    this.title = title;

    fetchMovies();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎬 MoviesListController initialized');
  }

  /// Fetch movies based on category or genre (first page)
  Future<void> fetchMovies() async {
    if (_isLoading.value) return;

    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _currentPage.value = 1;

      debugPrint('📥 Fetching movies: category=$category, genreId=$genreId, page=1');

      Map<String, dynamic>? response;

      if (genreId != null) {
        response = await _tmdbService.getMoviesByGenre(
          genreId: genreId!,
          page: 1,
        );
      } else if (category != null) {
        response = await _fetchByCategory(1);
      }

      if (response != null) {
        _updateMoviesFromResponse(response, isFirstPage: true);
        debugPrint('✅ Loaded ${_movies.length} movies');
      } else {
        _errorMessage.value = 'Failed to load movies';
        debugPrint('❌ Response is null');
      }
    } catch (e) {
      _errorMessage.value = 'Error: $e';
      debugPrint('❌ Error fetching movies: $e');
      _showErrorSnackbar('Failed to load movies: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load more movies (pagination)
  Future<void> loadMoreMovies() async {
    if (_isLoadingMore.value || !_hasMore.value || _isLoading.value) {
      return;
    }

    try {
      _isLoadingMore.value = true;
      final nextPage = _currentPage.value + 1;

      debugPrint('📥 Loading more movies: page=$nextPage');

      Map<String, dynamic>? response;

      if (genreId != null) {
        response = await _tmdbService.getMoviesByGenre(
          genreId: genreId!,
          page: nextPage,
        );
      } else if (category != null) {
        response = await _fetchByCategory(nextPage);
      }

      if (response != null) {
        _updateMoviesFromResponse(response, isFirstPage: false);
        debugPrint('✅ Loaded more movies. Total: ${_movies.length}');
      }
    } catch (e) {
      debugPrint('❌ Error loading more movies: $e');
      _showErrorSnackbar('Failed to load more movies');
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Refresh movies (pull to refresh)
  Future<void> refreshMovies() async {
    debugPrint('🔄 Refreshing movies');
    _currentPage.value = 1;
    _hasMore.value = true;
    await fetchMovies();
  }

  /// Fetch movies by category
  Future<Map<String, dynamic>?> _fetchByCategory(int page) async {
    switch (category!) {
      case MovieCategory.trending:
        return await _tmdbService.getTrendingMovies(page: page);
      case MovieCategory.topRated:
        return await _tmdbService.getTopRatedMovies(page: page);
      case MovieCategory.popular:
        return await _tmdbService.getPopularMovies(page: page);
      case MovieCategory.nowPlaying:
        return await _tmdbService.getNowPlayingMovies(page: page);
      case MovieCategory.upcoming:
        return await _tmdbService.getUpcomingMovies(page: page);
    }
  }

  /// Update movies list from API response
  void _updateMoviesFromResponse(
      Map<String, dynamic> response, {
        required bool isFirstPage,
      }) {
    final newMovies = response['results'] as List<Movie>;
    final totalPages = response['total_pages'] as int;
    final totalResults = response['total_results'] as int;
    final currentPage = response['page'] as int? ?? _currentPage.value;

    if (isFirstPage) {
      _movies.value = newMovies;
    } else {
      _movies.addAll(newMovies);
    }

    _currentPage.value = currentPage;
    _totalPages.value = totalPages;
    _totalResults.value = totalResults;
    _hasMore.value = currentPage < totalPages;

    debugPrint(
      '📊 Page: $currentPage/$totalPages | Movies: ${_movies.length}/$totalResults',
    );
  }

  /// Navigate to movie details
  void navigateToMovieDetails(int movieId) {
    debugPrint('🎬 Navigating to movie details: $movieId');
    Get.toNamed('/movie/$movieId');
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // ✅ FIXED: Get category display name without extension
  String getCategoryDisplayName() {
    if (category != null) {
      switch (category!) {
        case MovieCategory.trending:
          return 'Trending Movies';
        case MovieCategory.topRated:
          return 'Top Rated Movies';
        case MovieCategory.popular:
          return 'Popular Movies';
        case MovieCategory.nowPlaying:
          return 'Now Playing Movies';
        case MovieCategory.upcoming:
          return 'Upcoming Movies';
      }
    } else if (genreId != null) {
      return title;
    }
    return 'Movies';
  }

  /// Get category icon
  IconData getCategoryIcon() {
    if (category != null) {
      switch (category!) {
        case MovieCategory.trending:
          return Icons.local_fire_department;
        case MovieCategory.topRated:
          return Icons.star;
        case MovieCategory.popular:
          return Icons.trending_up;
        case MovieCategory.nowPlaying:
          return Icons.play_circle_outline;
        case MovieCategory.upcoming:
          return Icons.upcoming;
      }
    }
    return Icons.movie;
  }

  /// Get category color
  Color getCategoryColor() {
    if (category != null) {
      switch (category!) {
        case MovieCategory.trending:
          return Colors.orange;
        case MovieCategory.topRated:
          return Colors.amber;
        case MovieCategory.popular:
          return Colors.purple;
        case MovieCategory.nowPlaying:
          return Colors.green;
        case MovieCategory.upcoming:
          return Colors.blue;
      }
    }
    return Colors.red;
  }

  /// Check if can load more
  bool canLoadMore() {
    return !_isLoadingMore.value &&
        !_isLoading.value &&
        _hasMore.value;
  }

  /// Get progress percentage
  double getProgressPercentage() {
    if (_totalResults.value == 0) return 0.0;
    return (_movies.length / _totalResults.value).clamp(0.0, 1.0);
  }

  /// Get remaining movies count
  int getRemainingMoviesCount() {
    return (_totalResults.value - _movies.length).clamp(0, _totalResults.value);
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }

  /// Reset controller state
  void reset() {
    _movies.clear();
    _isLoading.value = false;
    _isLoadingMore.value = false;
    _currentPage.value = 1;
    _totalPages.value = 1;
    _totalResults.value = 0;
    _hasMore.value = true;
    _errorMessage.value = '';
  }

  @override
  void onClose() {
    debugPrint('🗑️ MoviesListController disposed');
    reset();
    super.onClose();
  }
}
