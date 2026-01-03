// lib/data/constants/category_config.dart
import 'package:flutter/material.dart';
import '../enums/movie_category.dart';

class CategoryConfig {
  static String getDisplayName(MovieCategory category) {
    switch (category) {
      case MovieCategory.trending:
        return 'Trending Movies';
      case MovieCategory.topRated:
        return 'Top Rated Movies';
      case MovieCategory.popular:
        return 'Popular Movies';
      case MovieCategory.nowPlaying:
        return 'Now Playing';
      case MovieCategory.upcoming:
        return 'Upcoming Movies';
    }
  }

  static IconData getIcon(MovieCategory category) {
    switch (category) {
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

  static Color getColor(MovieCategory category) {
    switch (category) {
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
}
