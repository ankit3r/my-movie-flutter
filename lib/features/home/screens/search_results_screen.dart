// lib/features/home/screens/search_results_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mymovie/common/widgets/movie_card/movie_card.dart';
import 'package:mymovie/features/home/widgets/search_widget.dart';
import '../../../data/models/movie_model.dart';
import '/app_importer.dart';
import '../controller/search_controller.dart';
import '../controller/movie_card_controller.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<MovieSearchController>();
    final scrollController = ScrollController();
    final isWeb = MediaQuery.of(context).size.width > 600;

    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (searchController.canLoadMore()) {
          searchController.loadMoreResults();
        }
      }
    });

    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            searchController.clearSearch();
            Get.back();
          },
        ),
        title: BuildSearchField(
          searchController: searchController,
          enableAutoFocus: false,
        ),
        // actions: [
        //   Obx(() => searchController.searchQuery.isNotEmpty
        //       ? IconButton(
        //     onPressed: () => searchController.clearSearch(),
        //     icon: const Icon(Icons.clear),
        //     tooltip: 'Clear',
        //   )
        //       : const SizedBox.shrink()),
        // ],
        actions: [
          GetBuilder<MovieSearchController>(
            builder: (ctrl) => IconButton(
              onPressed: ctrl.clearSearch,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear',
            ),
          ),
        ],
      ),
      body: Obx(() {
        final ctrl = searchController;

        if (ctrl.isSearching && ctrl.searchResults.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (ctrl.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  ctrl.searchQuery.isEmpty
                      ? 'Search for movies'
                      : 'No results found for "${ctrl.searchQuery}"',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ctrl.refreshSearch(),
          color: darkRed,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth-20; // full screen width [web:11]
              // breakpoint: < 600 => 1 column, otherwise 2 columns
              final int columns = maxWidth < 600 ? 1 : 3;
              // subtract spacing to avoid overflow
              const double horizontalSpacing = 8;
              final double itemWidth =
                  (maxWidth - (columns - 1) * horizontalSpacing) / columns;

              final results = ctrl.searchResults;

              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: horizontalSpacing,
                  runSpacing: 8,
                  children: [
                    for (final movie in results)
                      SizedBox(
                        width: itemWidth,
                        child: _buildMovieListItem(movie),
                      ),
                    if (ctrl.isSearching)
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Movie list item with MovieCardController for dynamic colors
  Widget _buildMovieListItem(Movie movie) {
    return MovieAnimatedCard(heroTag: 'list_movie_${movie.id}', movie: movie);
  }
}
