// lib/features/home/controller/movie_card_controller.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieCardController extends GetxController {
  final String imageUrl;

  MovieCardController(this.imageUrl);

  // Observable colors with better defaults
  final _cardColor = const Color(0xFF1A1A2E).obs;
  final _textColor = Colors.white.obs;
  final _isLoading = true.obs;

  Color get cardColor => _cardColor.value;
  Color get textColor => _textColor.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎨 MovieCardController initialized for: $imageUrl');
    if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
      _extractColors();
    } else {
      _setDefaultColors();
    }
  }

  // Extract dominant color from image with optimization
  Future<void> _extractColors() async {
    try {
      debugPrint('🔍 Extracting colors from: $imageUrl');

      final imageProvider = CachedNetworkImageProvider(imageUrl);

      // ✅ Extract palette with timeout
      final paletteGenerator = await PaletteGeneratorMaster.fromImageProvider(
        imageProvider,
        maximumColorCount: 16, // Increased for better color selection
        colorSpace: ColorSpace.rgb,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('⏱️ Palette generation timeout');
          _setDefaultColors();
          throw TimeoutException('Palette generation timeout');
        },
      );

      // ✅ Try multiple color options for best result
      Color? selectedColor;

      // Priority order: darkVibrant > vibrant > darkMuted > dominant > muted
      if (paletteGenerator.darkVibrantColor != null) {
        selectedColor = paletteGenerator.darkVibrantColor!.color;
        debugPrint('✅ Using darkVibrantColor: $selectedColor');
      } else if (paletteGenerator.vibrantColor != null) {
        selectedColor = paletteGenerator.vibrantColor!.color;
        debugPrint('✅ Using vibrantColor: $selectedColor');
      } else if (paletteGenerator.darkMutedColor != null) {
        selectedColor = paletteGenerator.darkMutedColor!.color;
        debugPrint('✅ Using darkMutedColor: $selectedColor');
      } else if (paletteGenerator.dominantColor != null) {
        selectedColor = paletteGenerator.dominantColor!.color;
        debugPrint('✅ Using dominantColor: $selectedColor');
      } else if (paletteGenerator.mutedColor != null) {
        selectedColor = paletteGenerator.mutedColor!.color;
        debugPrint('✅ Using mutedColor: $selectedColor');
      }

      if (selectedColor != null) {
        // ✅ Ensure the color is dark enough for good contrast
        _cardColor.value = _ensureDarkColor(selectedColor);
        _textColor.value = _getContrastTextColor(_cardColor.value);
        debugPrint('🎨 Final card color: ${_cardColor.value}');
        debugPrint('📝 Final text color: ${_textColor.value}');
      } else {
        debugPrint('⚠️ No suitable color found, using default');
        _setDefaultColors();
      }

    } on TimeoutException catch (e) {
      debugPrint('⏱️ Timeout: $e');
      _setDefaultColors();
    } catch (e) {
      debugPrint('❌ Color extraction failed: $e');
      _setDefaultColors();
    } finally {
      _isLoading.value = false;
    }
  }

  // ✅ Set default colors
  void _setDefaultColors() {
    _cardColor.value = const Color(0xFF1A1A2E);
    _textColor.value = Colors.white;
    _isLoading.value = false;
  }

  // ✅ Ensure color is dark enough for card background
  Color _ensureDarkColor(Color color) {
    final hsl = HSLColor.fromColor(color);

    // If color is too light, darken it significantly
    if (hsl.lightness > 0.5) {
      return hsl.withLightness(0.2).toColor();
    } else if (hsl.lightness > 0.4) {
      return hsl.withLightness(0.25).toColor();
    }

    // If color is too saturated, reduce it
    if (hsl.saturation > 0.85) {
      return hsl.withSaturation(0.7).toColor();
    }

    return color;
  }

  // ✅ Get contrasting text color (WCAG compliant)
  Color _getContrastTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final r = backgroundColor.red / 255.0;
    final g = backgroundColor.green / 255.0;
    final b = backgroundColor.blue / 255.0;

    // Apply gamma correction
    final rLuminance = r <= 0.03928
        ? r / 12.92
        : math.pow((r + 0.055) / 1.055, 2.4).toDouble();
    final gLuminance = g <= 0.03928
        ? g / 12.92
        : math.pow((g + 0.055) / 1.055, 2.4).toDouble();
    final bLuminance = b <= 0.03928
        ? b / 12.92
        : math.pow((b + 0.055) / 1.055, 2.4).toDouble();

    final luminance = 0.2126 * rLuminance + 0.7152 * gLuminance + 0.0722 * bLuminance;

    // Return white for dark backgrounds, black for light
    return luminance > 0.179 ? Colors.black87 : Colors.white;
  }

  @override
  void onClose() {
    debugPrint('🗑️ MovieCardController disposed for: $imageUrl');
    _cardColor.close();
    _textColor.close();
    _isLoading.close();
    super.onClose();
  }
}
