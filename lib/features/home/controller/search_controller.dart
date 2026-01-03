// lib/features/home/controller/search_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/movie_model.dart';
import '../../../service/tmdb_service.dart';

class MovieSearchController extends GetxController {
  static MovieSearchController get instance => Get.find<MovieSearchController>();

  final TmdbService _tmdbService = Get.find<TmdbService>();
  final searchTextController = TextEditingController();

  // Observables
  final _searchQuery = ''.obs;
  final _searchResults = <Movie>[].obs;
  final _isSearching = false.obs;
  final _isSearchVisible = false.obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _totalResults = 0.obs;
  final _hasMore = true.obs;

  // Getters
  String get searchQuery => _searchQuery.value;
  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching.value;
  bool get isSearchVisible => _isSearchVisible.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalResults => _totalResults.value;
  bool get hasMore => _hasMore.value;

  /// Show search bar
  void showSearch() {
    _isSearchVisible.value = true;
  }

  /// Hide search bar
  void hideSearch() {
    _isSearchVisible.value = false;
    clearSearch();
  }

  /// Update search query with debounce
  void updateSearchQuery(String query) {
    _searchQuery.value = query;

    if (query.isEmpty) {
      _searchResults.clear();
      _currentPage.value = 1;
      _hasMore.value = true;
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery.value == query && query.isNotEmpty) {
        performSearch(query);
      }
    });
  }

  /// Perform search (page 1) with retry
  Future<void> performSearch(String query) async {
    if (query.isEmpty || query.trim().isEmpty) {
      _showWarningSnackbar('Please enter a search term');
      return;
    }

    _isSearching.value = true;
    try {
      _searchQuery.value = query;
      _currentPage.value = 1;
      _searchResults.clear();

      debugPrint('🔍 Searching for: $query');

      final response = await _searchWithRetry(
        query: query.trim(),
        page: 1,
        maxRetries: 3,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        _totalPages.value = response['total_pages'] as int;
        _totalResults.value = response['total_results'] as int;
        _currentPage.value = response['page'] as int? ?? 1;
        _hasMore.value = _currentPage.value < _totalPages.value;

        _searchResults.value = movies;

        debugPrint('✅ Found ${movies.length} movies (${_totalResults.value} total)');

        if (movies.isNotEmpty) {
          Get.toNamed('/search-results');
        } else {
          _showInfoSnackbar('No movies found for "$query"');
        }
      } else {
        _showErrorSnackbar('Search failed after multiple attempts. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ Error searching movies: $e');
      _showErrorSnackbar('Search error: $e');
    } finally {
      _isSearching.value = false; // ✅ Always reset
    }
  }

  /// Load more results (pagination) with retry
  Future<void> loadMoreResults() async {
    if (_searchQuery.value.isEmpty ||
        _isSearching.value ||
        !_hasMore.value) {
      debugPrint('⚠️ Cannot load more: query empty or already loading or no more results');
      return;
    }

    _isSearching.value = true;
    try {
      final nextPage = _currentPage.value + 1;
      debugPrint('🔍 Loading more results: page $nextPage');

      final response = await _searchWithRetry(
        query: _searchQuery.value,
        page: nextPage,
        maxRetries: 3,
      );

      if (response != null) {
        final movies = response['results'] as List<Movie>;
        _totalPages.value = response['total_pages'] as int;
        _currentPage.value = response['page'] as int? ?? nextPage;
        _hasMore.value = _currentPage.value < _totalPages.value;

        _searchResults.addAll(movies);

        debugPrint('✅ Loaded ${movies.length} more movies. Total: ${_searchResults.length}');
      } else {
        debugPrint('❌ Failed to load more results after retries');
        _showErrorSnackbar('Failed to load more results. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ Error loading more search results: $e');
      _showErrorSnackbar('Failed to load more results: $e');
    } finally {
      _isSearching.value = false; // ✅ Always reset
    }
  }

  /// Core search call with retry logic
  Future<Map<String, dynamic>?> _searchWithRetry({
    required String query,
    required int page,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    Map<String, dynamic>? response;

    while (attempt < maxRetries && response == null) {
      attempt++;
      try {
        debugPrint('🔁 Search attempt $attempt for "$query" (page $page)');
        response = await _tmdbService.searchMovies(
          query: query,
          page: page,
        );
      } catch (e) {
        debugPrint('❌ Search attempt $attempt failed: $e');
      }

      if (response == null && attempt < maxRetries) {
        // small delay before retry
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }

    return response;
  }

  /// Clear search
  void clearSearch() {
    if (searchTextController.text.isEmpty) {
      _isSearchVisible.value = false;
    } else {
      searchTextController.clear();
      _searchQuery.value = '';
      _searchResults.clear();
      _currentPage.value = 1;
      _totalPages.value = 1;
      _totalResults.value = 0;
      _hasMore.value = true;
      debugPrint('🗑️ Search cleared');
    }
  }

  /// Refresh search results
  Future<void> refreshSearch() async {
    if (_searchQuery.value.isNotEmpty) {
      debugPrint('🔄 Refreshing search');
      await performSearch(_searchQuery.value);
    }
  }

  /// Check if can load more
  bool canLoadMore() {
    return !_isSearching.value &&
        _hasMore.value &&
        _searchQuery.value.isNotEmpty;
  }

  /// Progress helpers
  double getProgressPercentage() {
    if (_totalResults.value == 0) return 0.0;
    return (_searchResults.length / _totalResults.value).clamp(0.0, 1.0);
  }

  int getRemainingResultsCount() {
    return (_totalResults.value - _searchResults.length)
        .clamp(0, _totalResults.value);
  }

  /// Navigate to movie details
  void navigateToMovieDetails(int movieId) {
    debugPrint('🎬 Navigating to movie: $movieId');
    Get.toNamed('/movie/$movieId');
  }

  // Snackbars
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
      shouldIconPulse: true,
    );
  }

  void _showWarningSnackbar(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber, color: Colors.white),
    );
  }

  void _showInfoSnackbar(String message) {
    Get.snackbar(
      'No Results',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }


  @override
  void onInit() {
    super.onInit();
    debugPrint('🔍 MovieSearchController initialized');
  }

  @override
  void onClose() {
    searchTextController.dispose();
    debugPrint('🗑️ MovieSearchController disposed');
    super.onClose();
  }
}
