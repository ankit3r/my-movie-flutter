import 'package:flutter/material.dart';
import 'package:mymovie/features/home/controller/search_controller.dart';

import '../../../app_importer.dart';

class BuildSearchField extends StatelessWidget {
   BuildSearchField({super.key,required this.searchController,required this.enableAutoFocus});
  MovieSearchController searchController;
  bool enableAutoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController.searchTextController,
      // onChanged: searchController.updateSearchQuery,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search movies...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        // prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: GetBuilder<MovieSearchController>(
          builder: (ctrl) {
            if (ctrl.isSearching) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      autofocus: enableAutoFocus,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        searchController.performSearch(value);
      },
    );
  }
}
