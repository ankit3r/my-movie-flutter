// lib/features/details/controller/movie_details_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/movie_details_model.dart';
import '../../../data/models/movie_model.dart';
import '../../../service/tmdb_service.dart';

class MovieDetailsController extends GetxController {
  static MovieDetailsController get instance =>
      Get.find<MovieDetailsController>();

  final TmdbService _tmdbService = Get.find<TmdbService>();

  final Rx<MovieDetails?> _movieDetails = Rx<MovieDetails?>(null);
  final RxList<dynamic> _cast = <dynamic>[].obs;
  final RxList<Movie> _similarMovies = <Movie>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;
  final RxInt _retryCount = 0.obs;

  MovieDetails? get movieDetails => _movieDetails.value;
  List<dynamic> get cast => _cast;
  List<Movie> get similarMovies => _similarMovies;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  int get retryCount => _retryCount.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  int? _currentMovieId;

  @override
  void onInit() {
    super.onInit();
    final movieId = int.tryParse(Get.parameters['id'] ?? '0');
    if (movieId != null && movieId > 0) {
      _currentMovieId = movieId;
      loadMovieDetails(movieId);
    }
  }

  /// Generic retry with exponential backoff + optional jitter
  Future<T> _retryWithBackoff<T>({
    required Future<T> Function() operation,
    required String operationName,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool addJitter = true,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxAttempts) {
      try {
        attempt++;
        _retryCount.value = attempt;

        debugPrint('🔄 $operationName - Attempt $attempt/$maxAttempts');

        final result = await operation();

        debugPrint('✅ $operationName - Success on attempt $attempt');
        return result;
      } catch (e) {
        debugPrint('❌ $operationName - Attempt $attempt failed: $e');

        if (attempt >= maxAttempts) {
          debugPrint('⛔ $operationName - All $maxAttempts attempts failed');
          rethrow;
        }

        final waitTime = delay * (attempt * backoffMultiplier);
        final jitterDelay = addJitter
            ? Duration(
          milliseconds: waitTime.inMilliseconds +
              (DateTime.now().millisecondsSinceEpoch % 1000),
        )
            : waitTime;

        debugPrint(
          '⏳ $operationName - Waiting ${jitterDelay.inSeconds}s before retry...',
        );

        await Future.delayed(jitterDelay);
      }
    }

    throw Exception('Max retries ($maxAttempts) reached for $operationName');
  }

  /// Load movie details with retry + error state
  Future<void> loadMovieDetails(int movieId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _retryCount.value = 0;
      _currentMovieId = movieId;

      debugPrint('📽️ Loading movie details for ID: $movieId');

      // Movie details (with videos, credits, reviews from append_to_response)
      final details = await _retryWithBackoff<MovieDetails?>(
        operation: () => _tmdbService.getMovieDetails(movieId),
        operationName: 'Movie Details (ID: $movieId)',
        maxAttempts: 3,
        initialDelay: const Duration(seconds: 1),
      );

      if (details == null) {
        throw Exception('Movie details returned null');
      }

      _movieDetails.value = details;
      debugPrint(
        '✅ Movie loaded: ${details.title} '
            '(reviews: ${details.reviews?.length ?? 0})',
      );

      // Cast (semi‑critical)
      try {
        final castData = await _retryWithBackoff<List<dynamic>>(
          operation: () => _tmdbService.getMovieCast(movieId),
          operationName: 'Cast (ID: $movieId)',
          maxAttempts: 2,
          initialDelay: const Duration(milliseconds: 500),
        );
        _cast.value = castData;
        debugPrint('✅ Cast loaded: ${castData.length} members');
      } catch (e) {
        debugPrint('⚠️ Cast loading failed (non‑critical): $e');
        _cast.clear();
      }

      // Similar movies (non‑critical)
      try {
        final similar = await _retryWithBackoff<List<Movie>>(
          operation: () => _tmdbService.getSimilarMovies(movieId),
          operationName: 'Similar Movies (ID: $movieId)',
          maxAttempts: 2,
          initialDelay: const Duration(milliseconds: 500),
        );
        _similarMovies.value = similar;
        debugPrint('✅ Similar movies loaded: ${similar.length} movies');
      } catch (e) {
        debugPrint('⚠️ Similar movies loading failed (non‑critical): $e');
        _similarMovies.clear();
      }
    } on TimeoutException catch (e) {
      _handleError(
        'Request timed out. Please check your internet connection.',
        e,
      );
    } catch (e) {
      _handleError('Failed to load movie details.', e);
    } finally {
      _isLoading.value = false;
      _retryCount.value = 0;
    }
  }

  /// Handle errors with user‑friendly message
  void _handleError(String message, dynamic error) {
    debugPrint('❌ Error: $message - $error');
    _errorMessage.value = message;

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Navigate to another movie details (handles same route navigation)
  void navigateToMovieDetails(int movieId) {
    debugPrint('🔀 Navigating to movie ID: $movieId');

    if (_currentMovieId == movieId) {
      debugPrint('↻ Same movie, reloading...');
      reloadMovie();
      return;
    }

    Get.delete<MovieDetailsController>(force: true);
    Get.offNamed('/movie/$movieId');
  }

  /// Reload current movie (used by Retry button)
  void reloadMovie() {
    if (_currentMovieId != null) {
      debugPrint('🔄 Reloading movie ID: $_currentMovieId');
      loadMovieDetails(_currentMovieId!);
    }
  }

  /// Manual retry (used by UI error state)
  void retry() {
    if (_currentMovieId != null) {
      debugPrint('🔁 Manual retry for movie ID: $_currentMovieId');
      loadMovieDetails(_currentMovieId!);
    } else {
      final movieId = int.tryParse(Get.parameters['id'] ?? '0');
      if (movieId != null && movieId > 0) {
        _currentMovieId = movieId;
        loadMovieDetails(movieId);
      }
    }
  }

  @override
  void onClose() {
    debugPrint('🗑️ MovieDetailsController disposed');
    super.onClose();
  }
}
