// lib/data/services/tmdb_service.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/api/api_config.dart';
import '../data/models/movie_details_model.dart';
import '../data/models/movie_model.dart';

class TmdbService extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiConfig.baseUrl;

    // Add authorization header
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] =
      'Bearer ${ApiConfig.readAccessToken}';
      return request;
    });

    // Timeout configuration
    httpClient.timeout = const Duration(seconds: 30);

    debugPrint('🎬 TmdbService initialized');
  }

  /// Build query parameters
  Map<String, String> _buildParams({
    int page = 1,
    String? language,
    String? region,
    Map<String, String>? additionalParams,
  }) {
    final params = <String, String>{
      'api_key': ApiConfig.apiKey,
      'page': page.toString(),
      'language': language ?? 'en-US',
    };

    if (region != null) params['region'] = region;
    if (additionalParams != null) params.addAll(additionalParams);

    return params;
  }

  // ==================== MOVIE ENDPOINTS ====================

  /// Get popular movies
  Future<Map<String, dynamic>?> getPopularMovies({int page = 1}) async {
    try {
      debugPrint('📥 Fetching popular movies (page $page)');

      final response = await get(
        ApiConfig.popularMovies,
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching popular movies: $e');
      return null;
    }
  }

  /// Get top rated movies
  Future<Map<String, dynamic>?> getTopRatedMovies({int page = 1}) async {
    try {
      debugPrint('📥 Fetching top rated movies (page $page)');

      final response = await get(
        ApiConfig.topRatedMovies,
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching top rated movies: $e');
      return null;
    }
  }

  /// Get upcoming movies
  Future<Map<String, dynamic>?> getUpcomingMovies({int page = 1}) async {
    try {
      debugPrint('📥 Fetching upcoming movies (page $page)');

      final response = await get(
        ApiConfig.upcomingMovies,
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching upcoming movies: $e');
      return null;
    }
  }

  /// Get now playing movies
  Future<Map<String, dynamic>?> getNowPlayingMovies({int page = 1}) async {
    try {
      debugPrint('📥 Fetching now playing movies (page $page)');

      final response = await get(
        ApiConfig.nowPlayingMovies,
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching now playing movies: $e');
      return null;
    }
  }

  /// Get trending movies
  Future<Map<String, dynamic>?> getTrendingMovies({
    String timeWindow = 'week',
    int page = 1,
  }) async {
    try {
      debugPrint('📥 Fetching trending movies (page $page, $timeWindow)');

      final response = await get(
        '/trending/movie/$timeWindow',
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching trending movies: $e');
      return null;
    }
  }

  /// Search movies
  Future<Map<String, dynamic>?> searchMovies({
    required String query,
    int page = 1,
    bool includeAdult = false,
    int? year,
  }) async {
    try {
      debugPrint('🔍 Searching movies: "$query" (page $page)');

      final params = <String, String>{
        'query': query,
        'include_adult': includeAdult.toString(),
      };

      if (year != null) params['year'] = year.toString();

      final response = await get(
        ApiConfig.searchMovie,
        query: _buildParams(page: page, additionalParams: params),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      final result = _parseMovieResponse(response.body);
      debugPrint('✅ Found ${result?['total_results'] ?? 0} results');
      return result;
    } catch (e) {
      debugPrint('❌ Error searching movies: $e');
      return null;
    }
  }

  /// Get movies by genre
  Future<Map<String, dynamic>?> getMoviesByGenre({
    required int genreId,
    int page = 1,
    String sortBy = 'popularity.desc',
  }) async {
    try {
      debugPrint('📥 Fetching movies by genre $genreId (page $page)');

      final params = <String, String>{
        'with_genres': genreId.toString(),
        'sort_by': sortBy,
      };

      final response = await get(
        ApiConfig.discoverMovie,
        query: _buildParams(page: page, additionalParams: params),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching movies by genre: $e');
      return null;
    }
  }

  /// Get movie details (with videos, credits, reviews)
  Future<MovieDetails?> getMovieDetails(int movieId) async {
    try {
      debugPrint('📥 Fetching movie details: $movieId');

      final response = await get(
        '/movie/$movieId',
        query: _buildParams(
          additionalParams: const {
            // important for videos / credits / reviews in MovieDetails
            'append_to_response': 'videos,credits,reviews',
          },
        ),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return null;
      }

      debugPrint(
        '✅ Movie details loaded (reviews: '
            '${(response.body['reviews']?['results'] as List?)?.length ?? 0})',
      );

      return MovieDetails.fromJson(response.body);
    } catch (e) {
      debugPrint('❌ Error fetching movie details: $e');
      return null;
    }
  }

  /// Get movie cast (separate endpoint, used by controller)
  Future<List<dynamic>> getMovieCast(int movieId) async {
    try {
      debugPrint('📥 Fetching cast for movie: $movieId');

      final response = await get(
        '/movie/$movieId/credits',
        query: _buildParams(),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return [];
      }

      final cast = response.body['cast'] as List<dynamic>;
      debugPrint('✅ Loaded ${cast.length} cast members');
      return cast;
    } catch (e) {
      debugPrint('❌ Error fetching movie cast: $e');
      return [];
    }
  }

  /// Get similar movies
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      debugPrint('📥 Fetching similar movies for: $movieId');

      final response = await get(
        '/movie/$movieId/similar',
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return [];
      }

      final results = response.body['results'] as List;
      final movies = results.map((json) => Movie.fromJson(json)).toList();
      debugPrint('✅ Loaded ${movies.length} similar movies');
      return movies;
    } catch (e) {
      debugPrint('❌ Error fetching similar movies: $e');
      return [];
    }
  }

  /// Get movie recommendations
  Future<List<Movie>> getMovieRecommendations(int movieId,
      {int page = 1}) async {
    try {
      debugPrint('📥 Fetching recommendations for: $movieId');

      final response = await get(
        '/movie/$movieId/recommendations',
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return [];
      }

      final results = response.body['results'] as List;
      final movies = results.map((json) => Movie.fromJson(json)).toList();
      debugPrint('✅ Loaded ${movies.length} recommendations');
      return movies;
    } catch (e) {
      debugPrint('❌ Error fetching recommendations: $e');
      return [];
    }
  }

  // ==================== GENRE ENDPOINTS ====================

  /// Get movie genres
  Future<List<Genre>> getMovieGenres() async {
    try {
      debugPrint('📥 Fetching movie genres');

      final response = await get(
        ApiConfig.movieGenres,
        query: _buildParams(),
      );

      if (response.status.hasError) {
        debugPrint('❌ Error: ${response.statusText}');
        return [];
      }

      final genres = response.body['genres'] as List;
      final genreList =
      genres.map((json) => Genre.fromJson(json)).toList();
      debugPrint('✅ Loaded ${genreList.length} genres');
      return genreList;
    } catch (e) {
      debugPrint('❌ Error fetching genres: $e');
      return [];
    }
  }

  /// Discover movies by genre (Legacy)
  Future<List<Movie>> discoverMoviesByGenre({
    required int genreId,
    int page = 1,
    String? sortBy,
    int? year,
    double? voteAverageGte,
  }) async {
    try {
      final params = <String, String>{
        'with_genres': genreId.toString(),
      };

      if (sortBy != null) params['sort_by'] = sortBy;
      if (year != null) params['year'] = year.toString();
      if (voteAverageGte != null) {
        params['vote_average.gte'] = voteAverageGte.toString();
      }

      final response = await get(
        ApiConfig.discoverMovie,
        query: _buildParams(page: page, additionalParams: params),
      );

      if (response.status.hasError) {
        return [];
      }

      final results = response.body['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error discovering movies: $e');
      return [];
    }
  }

  /// Advanced discover movies
  Future<Map<String, dynamic>?> discoverMovies({
    int page = 1,
    String? sortBy,
    List<int>? withGenres,
    List<int>? withoutGenres,
    int? year,
    double? voteAverageGte,
    double? voteAverageLte,
    int? voteCountGte,
    String? releaseDateGte,
    String? releaseDateLte,
  }) async {
    try {
      final additionalParams = <String, String>{};

      if (sortBy != null) additionalParams['sort_by'] = sortBy;
      if (withGenres != null && withGenres.isNotEmpty) {
        additionalParams['with_genres'] = withGenres.join(',');
      }
      if (withoutGenres != null && withoutGenres.isNotEmpty) {
        additionalParams['without_genres'] = withoutGenres.join(',');
      }
      if (year != null) additionalParams['year'] = year.toString();
      if (voteAverageGte != null) {
        additionalParams['vote_average.gte'] = voteAverageGte.toString();
      }
      if (voteAverageLte != null) {
        additionalParams['vote_average.lte'] = voteAverageLte.toString();
      }
      if (voteCountGte != null) {
        additionalParams['vote_count.gte'] = voteCountGte.toString();
      }
      if (releaseDateGte != null) {
        additionalParams['release_date.gte'] = releaseDateGte;
      }
      if (releaseDateLte != null) {
        additionalParams['release_date.lte'] = releaseDateLte;
      }

      final response = await get(
        ApiConfig.discoverMovie,
        query: _buildParams(
          page: page,
          additionalParams: additionalParams,
        ),
      );

      if (response.status.hasError) {
        return null;
      }

      return _parseMovieResponse(response.body);
    } catch (e) {
      debugPrint('❌ Error discovering movies: $e');
      return null;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Get configuration
  Future<Map<String, dynamic>?> getConfiguration() async {
    try {
      final response = await get(
        '/configuration',
        query: _buildParams(),
      );

      if (response.status.hasError) {
        return null;
      }

      return response.body;
    } catch (e) {
      debugPrint('❌ Error fetching configuration: $e');
      return null;
    }
  }

  /// Get movie videos
  Future<List<dynamic>> getMovieVideos(int movieId) async {
    try {
      final response = await get(
        '/movie/$movieId/videos',
        query: _buildParams(),
      );

      if (response.status.hasError) {
        return [];
      }

      return response.body['results'] as List<dynamic>;
    } catch (e) {
      debugPrint('❌ Error fetching movie videos: $e');
      return [];
    }
  }

  /// Get movie reviews (separate endpoint, if you need paging)
  Future<Map<String, dynamic>?> getMovieReviews(int movieId,
      {int page = 1}) async {
    try {
      final response = await get(
        '/movie/$movieId/reviews',
        query: _buildParams(page: page),
      );

      if (response.status.hasError) {
        return null;
      }

      return response.body;
    } catch (e) {
      debugPrint('❌ Error fetching movie reviews: $e');
      return null;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Parse movie response with pagination data
  Map<String, dynamic> _parseMovieResponse(dynamic responseBody) {
    final data = responseBody as Map<String, dynamic>;

    return {
      'results': (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList(),
      'total_pages': data['total_pages'] ?? 1,
      'total_results': data['total_results'] ?? 0,
      'page': data['page'] ?? 1,
    };
  }

  /// Check if service is healthy
  Future<bool> checkHealth() async {
    try {
      final response = await get(
        '/configuration',
        query: _buildParams(),
      );

      return !response.status.hasError;
    } catch (e) {
      debugPrint('❌ Health check failed: $e');
      return false;
    }
  }
}
