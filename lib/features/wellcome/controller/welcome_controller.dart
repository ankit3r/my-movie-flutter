import 'package:get/get.dart';
import '/routes/app_routes.dart';

class WelcomeController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Auto navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed(AppRoutes.home); // Use offNamed to replace current route
    });
  }
}
