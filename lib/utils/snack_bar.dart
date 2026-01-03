import 'package:mymovie/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mymovie/app_importer.dart'; // where darkRed, margins etc. are defined

class SnackBarHelper {
  static void showMessage(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 2),
        SnackPosition position = SnackPosition.BOTTOM,
      }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: ThemeController.instance.isDarkMode ? lightRed : darkRed,
      colorText:Colors.white,
      margin: const EdgeInsets.all(mediumMargin),
      borderRadius: smallBorderRadius,
      duration: duration,
    );
  }
}
