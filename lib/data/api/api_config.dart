// lib/data/api/api_config.dart
class ApiConfig {
  // Get your API key from https://www.themoviedb.org/settings/api
  static const String apiKey = 'd48151cc5542ca8f17f771590adb14fd';
  static const String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNDgxNTFjYzU1NDJjYThmMTdmNzcxNTkwYWRiMTRmZCIsIm5iZiI6MTY3OTg5Mjg3Mi4yNDgsInN1YiI6IjY0MjEyMTg4Njg5MjljMDBmZDlhN2U4NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Bq62mpBuVfRNijZYtiGoH2zyvHbXqOudlu-q8jWgasw';

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageUrl = 'https://image.tmdb.org/t/p/original';

  // API Endpoints
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String trendingMovies = '/trending/movie/week';
  static const String searchMovie = '/search/movie';
  static const String movieDetails = '/movie';
  static const String movieCredits = '/movie/{movie_id}/credits';
  static const String movieVideos = '/movie/{movie_id}/videos';
  static const String movieReviews = '/movie/{movie_id}/reviews';
  static const String similarMovies = '/movie/{movie_id}/similar';
  static const String movieRecommendations = '/movie/{movie_id}/recommendations';

  // TV Shows Endpoints
  static const String popularTvShows = '/tv/popular';
  static const String topRatedTvShows = '/tv/top_rated';
  static const String trendingTvShows = '/trending/tv/week';

  // Genres
  static const String movieGenres = '/genre/movie/list';
  static const String tvGenres = '/genre/tv/list';
  static const String discoverMovie = '/discover/movie';

  // Person
  static const String personDetails = '/person';
  static const String personMovieCredits = '/person/{person_id}/movie_credits';
}
