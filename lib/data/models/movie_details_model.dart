// lib/data/models/movie_details_model.dart
class MovieDetails {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int? voteCount;
  final int? runtime;
  final List<Genre>? genres;
  final List<dynamic>? videos;   // appended videos.results
  final List<dynamic>? credits;  // appended credits.cast
  final List<dynamic>? reviews;  // appended reviews.results
  final String? tagline;
  final String? status;
  final int? budget;
  final int? revenue;

  MovieDetails({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    this.voteCount,
    this.runtime,
    this.genres,
    this.videos,
    this.credits,
    this.reviews,
    this.tagline,
    this.status,
    this.budget,
    this.revenue,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'],
      runtime: json['runtime'],
      genres: json['genres'] != null
          ? (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList()
          : null,
      videos: json['videos']?['results'] as List<dynamic>?,   // may be null
      credits: json['credits']?['cast'] as List<dynamic>?,    // may be null
      reviews: json['reviews']?['results'] as List<dynamic>?, // may be null
      tagline: json['tagline'],
      status: json['status'],
      budget: json['budget'],
      revenue: json['revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'runtime': runtime,
      'genres': genres?.map((g) => g.toJson()).toList(),
      'tagline': tagline,
      'status': status,
      'budget': budget,
      'revenue': revenue,
      // videos / credits / reviews usually not sent back
    };
  }

  // Getter for full poster URL
  String? get posterUrl {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  // Getter for full backdrop URL
  String? get backdropUrl {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
