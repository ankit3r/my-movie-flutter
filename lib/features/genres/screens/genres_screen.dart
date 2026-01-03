// lib/features/genres/screens/genres_screen.dart
import 'package:flutter/material.dart';
import 'package:mymovie/app_importer.dart';
import '../../../data/constants/genre_constants.dart';
import '../../../data/enums/movie_category.dart';
import '../../home/screens/movies_list_screen.dart';


class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        elevation: 0,
        title: const Text(
          appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [

          IconButton(
            onPressed: () {
              // Show category menu (Trending, Popular, etc.)
              _showCategoryMenu(context);
            },
            icon: const Icon(Icons.dashboard_rounded, color: Colors.white,size: 33,),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient blob
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Genre grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: GenreConstants.genreIds.length,
              itemBuilder: (context, index) {
                final genreName = GenreConstants.genreIds.keys.elementAt(index);
                final genreId = GenreConstants.genreIds[genreName]!;

                return _buildGenreCard(
                  genreName: genreName,
                  genreId: genreId,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreCard({
    required String genreName,
    required int genreId,
  }) {
    final colors = GenreConstants.genreColors[genreName] ??
        [Colors.purple, Colors.deepPurple];
    final icon = GenreConstants.genreIcons[genreName] ?? Icons.movie;

    return GestureDetector(
      onTap: () {
        Get.to(() => MoviesListScreen(
          genreId: genreId,
          title: '$genreName Movies',
          icon: icon,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background icon (subtle)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 60,
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            // Genre name
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  genreName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: lightRed,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movie Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryItem(
              icon: Icons.local_fire_department,
              title: 'Trending Movies',
              color: Colors.orange,
              onTap: () {
                Get.back();
                Get.to(() => const MoviesListScreen(
                  category: MovieCategory.trending,
                  title: 'Trending Movies',
                  icon: Icons.local_fire_department,
                ));
              },
            ),
            _buildCategoryItem(
              icon: Icons.star,
              title: 'Top Rated Movies',
              color: Colors.amber,
              onTap: () {
                Get.back();
                Get.to(() => const MoviesListScreen(
                  category: MovieCategory.topRated,
                  title: 'Top Rated Movies',
                  icon: Icons.star,
                ));
              },
            ),
            _buildCategoryItem(
              icon: Icons.trending_up,
              title: 'Popular Movies',
              color: Colors.purple,
              onTap: () {
                Get.back();
                Get.to(() => const MoviesListScreen(
                  category: MovieCategory.popular,
                  title: 'Popular Movies',
                  icon: Icons.trending_up,
                ));
              },
            ),
            _buildCategoryItem(
              icon: Icons.play_circle_outline,
              title: 'Now Playing',
              color: Colors.green,
              onTap: () {
                Get.back();
                Get.to(() => const MoviesListScreen(
                  category: MovieCategory.nowPlaying,
                  title: 'Now Playing',
                  icon: Icons.play_circle_outline,
                ));
              },
            ),
            _buildCategoryItem(
              icon: Icons.upcoming,
              title: 'Upcoming Movies',
              color: Colors.blue,
              onTap: () {
                Get.back();
                Get.to(() => const MoviesListScreen(
                  category: MovieCategory.upcoming,
                  title: 'Upcoming Movies',
                  icon: Icons.upcoming,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
