
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

 void snackBarMessage(String message) {
  GetSnackBar(
    message: message,
    duration: const Duration(seconds: 1),
    snackPosition: SnackPosition.TOP,
  ).show();
}