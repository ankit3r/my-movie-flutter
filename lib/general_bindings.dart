import 'package:get/get.dart';
import 'package:mymovie/service/tmdb_service.dart';
import '/theme/app_theme.dart';
import 'features/home/controller/carousel_controller.dart';
import 'features/home/controller/home_controller.dart';
import 'features/home/controller/search_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Services first
    Get.put(TmdbService(), permanent: true);

    // Controllers
    Get.put(ThemeController(), permanent: true);
    Get.put(HomeController());
    Get.put(CarouselController());
    Get.put(MovieSearchController());
  }
}
