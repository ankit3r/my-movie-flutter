// lib/data/constants/genre_constants.dart
import 'package:flutter/material.dart';

class GenreConstants {
  // Genre IDs from TMDB
  static const Map<String, int> genreIds = {
    'Action': 28,
    'Adventure': 12,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Documentary': 99,
    'Drama': 18,
    'Family': 10751,
    'Fantasy': 14,
    'History': 36,
    'Horror': 27,
    'Music': 10402,
    'Mystery': 9648,
    'Romance': 10749,
    'Science Fiction': 878,
    'TV Movie': 10770,
    'Thriller': 53,
    'War': 10752,
    'Western': 37,
  };

  // Genre icons
  static const Map<String, IconData> genreIcons = {
    'Action': Icons.flash_on,
    'Adventure': Icons.explore,
    'Animation': Icons.animation,
    'Comedy': Icons.theater_comedy,
    'Crime': Icons.gavel,
    'Documentary': Icons.movie_filter,
    'Drama': Icons.masks,
    'Family': Icons.family_restroom,
    'Fantasy': Icons.auto_awesome,
    'History': Icons.history_edu,
    'Horror': Icons.psychology,
    'Music': Icons.music_note,
    'Mystery': Icons.search,
    'Romance': Icons.favorite,
    'Science Fiction': Icons.rocket_launch,
    'TV Movie': Icons.tv,
    'Thriller': Icons.whatshot,
    'War': Icons.military_tech,
    'Western': Icons.terrain,
  };

  // Genre colors (gradient pairs)
  static const Map<String, List<Color>> genreColors = {
    'Action': [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
    'Adventure': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    'Animation': [Color(0xFFFFBE0B), Color(0xFFFB5607)],
    'Comedy': [Color(0xFFFFBE0B), Color(0xFFFB5607)],
    'Crime': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    'Documentary': [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    'Drama': [Color(0xFFF857A6), Color(0xFFFF5858)],
    'Family': [Color(0xFF43E97B), Color(0xFF38F9D7)],
    'Fantasy': [Color(0xFFFA709A), Color(0xFFFEE140)],
    'History': [Color(0xFF30CFD0), Color(0xFF330867)],
    'Horror': [Color(0xFFEB3349), Color(0xFFF45C43)],
    'Music': [Color(0xFFDD5E89), Color(0xFFF7BB97)],
    'Mystery': [Color(0xFF4568DC), Color(0xFFB06AB3)],
    'Romance': [Color(0xFFFF6B95), Color(0xFFFF9472)],
    'Science Fiction': [Color(0xFF667EEA), Color(0xFF764BA2)],
    'TV Movie': [Color(0xFF7F7FD5), Color(0xFF86A8E7)],
    'Thriller': [Color(0xFFFF512F), Color(0xFFDD2476)],
    'War': [Color(0xFF232526), Color(0xFF414345)],
    'Western': [Color(0xFFD38312), Color(0xFFA83279)],
  };
}
