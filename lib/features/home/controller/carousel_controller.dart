// lib/features/home/controller/carousel_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CarouselController extends GetxController {
  static CarouselController get instance => Get.find<CarouselController>();

  final pageController = PageController();
  Timer? _autoSlideTimer;

  final _currentPage = 0.obs;
  int get currentPage => _currentPage.value;

  @override
  void onInit() {
    super.onInit();
    startAutoSlide();
  }

  void startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        final nextPage = (_currentPage.value + 1) % 5; // 5 featured movies
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int page) {
    _currentPage.value = page;
  }

  void stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  void resumeAutoSlide() {
    startAutoSlide();
  }

  @override
  void onClose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
