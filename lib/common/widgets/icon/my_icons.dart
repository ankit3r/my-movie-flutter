import 'package:mymovie/theme/app_theme.dart';
import 'package:mymovie/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyIconWidget extends StatelessWidget {
  final IconData icon;
  final double iconSize;

  const MyIconWidget({
    super.key,
    required this.icon,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {

    return Obx(() => Icon(
      icon,
      size: iconSize,
      color: ThemeController.instance.isDarkMode ? Colors.white : darkRed,
    ));
  }
}
