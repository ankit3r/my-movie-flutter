import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymovie/common/widgets/movie_card/movie_card.dart';

import '../../../data/models/movie_model.dart';
import '../../../data/enums/movie_category.dart';
import '/app_importer.dart';
import '../controller/movies_list_controller.dart';

class MoviesListScreen extends StatelessWidget {
  final MovieCategory? category;
  final int? genreId;
  final String title;
  final IconData icon;

  const MoviesListScreen({
    super.key,
    this.category,
    this.genreId,
    required this.title,
    this.icon = Icons.movie,
  });

  @override
  Widget build(BuildContext context) {
    final controllerTag = '${category?.name ?? genreId}_$title';

    final controller = Get.put(
      MoviesListController(),
      tag: controllerTag,
    );

    controller.init(
      category: category,
      genreId: genreId,
      title: title,
    );

    final scrollController = ScrollController();

    /// Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!controller.isLoadingMore && controller.hasMore) {
          controller.loadMoreMovies();
        }
      }
    });

    return WillPopScope(
      onWillPop: () async {
        scrollController.dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightRed,
        appBar: _buildAppBar(controller),
        body: Obx(() => _buildBody(controller, scrollController)),

        /// ✅ Bottom page info
        bottomNavigationBar: Obx(
              () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: lightRed,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${controller.currentPage} / ${controller.totalPages}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${controller.movies.length} movies',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- APP BAR ----------------
  PreferredSizeWidget _buildAppBar(MoviesListController controller) {
    return AppBar(
      backgroundColor: lightRed,
      foregroundColor: Colors.white,
      title: Text(title, overflow: TextOverflow.ellipsis),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(
              () => IconButton(
            onPressed: controller.isLoading
                ? null
                : () => controller.refreshMovies(),
            icon: controller.isLoading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }

  /// ---------------- BODY ----------------
  Widget _buildBody(
      MoviesListController controller,
      ScrollController scrollController,
      ) {
    if (controller.isLoading && controller.movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.movies.isEmpty) {
      return _buildEmptyState(controller);
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshMovies(),
      color: lightRed,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: controller.movies.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.movies.length) {
            return _buildBottomLoader(controller);
          }
          return _buildAnimatedMovieCard(controller.movies[index]);
        },
      ),
    );
  }

  /// ---------------- EMPTY STATE ----------------
  Widget _buildEmptyState(MoviesListController controller) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: controller.refreshMovies,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
        style: ElevatedButton.styleFrom(backgroundColor: darkRed),
      ),
    );
  }

  /// ---------------- MOVIE CARD ----------------
  Widget _buildAnimatedMovieCard(Movie movie) {
    return MovieAnimatedCard(heroTag:'list_movie_${movie.id}',movie: movie,);
  }

  /// ---------------- BOTTOM LOADER ----------------
  Widget _buildBottomLoader(MoviesListController controller) {
    if (controller.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!controller.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "You've reached the end",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
