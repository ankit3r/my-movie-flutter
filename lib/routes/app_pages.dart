import 'package:mymovie/app_importer.dart';
import '../features/details/controller/movie_details_controller.dart';
import '../features/details/screen/movie_details_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/search_results_screen.dart';
import '../features/wellcome/screens/welcome_screen.dart';

class AppRoutePages {
  static var getPages = [
    GetPage(
      name: AppRoutes.start,
      page: () => WelcomeScreen(),
      transition: Transition.size,
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.searchResult,
      page: () => SearchResultsScreen(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: '/movie/:id',
      page: () => const MovieDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MovieDetailsController());
      }),
    ),
  ];
}
