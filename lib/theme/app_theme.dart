import 'package:mymovie/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Primary color scheme
      primarySwatch: _createMaterialColor(darkRed),
      primaryColor: darkRed,

      colorScheme: const ColorScheme.light(
        primary: darkRed,
        secondary: accentPurple,
        surface: Colors.white,
        // ✅ replaced deprecated background with surfaceContainerLowest
        surfaceContainerLowest: Color(0xFFF5F5F5),
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onError: Colors.white,
        outline: borderRed,
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightRed,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      // Scaffold theme
      scaffoldBackgroundColor: Color(0xFFF1F1F1),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // text/icon color
          backgroundColor: darkRed, // button fill color
          elevation: 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: darkRed, width: 1.5), // 🔥 border
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkRed,
          side: const BorderSide(color: borderRed, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: darkRed,
        size: 24,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return lightRed;
          }
          return Colors.grey.shade300;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.grey;
        }),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkRed,
        foregroundColor: Colors.white,
      ),

      // Inside AppTheme.lightTheme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: darkRed,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),


    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Primary color scheme
      primarySwatch: _createMaterialColor(darkRed),
      primaryColor: darkRed,

      colorScheme: const ColorScheme.dark(
        primary: darkRed,
        secondary: accentPurple,
        surface: Color(0xFF1E1E1E),
        // ✅ replaced deprecated background with surfaceContainerLowest
        surfaceContainerLowest: Color(0xFF121212),
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        outline: borderRed,
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkRed),
        actionsIconTheme: IconThemeData(color: darkRed),
      ),
      // Scaffold theme
      scaffoldBackgroundColor:  Colors.black,

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: lightRed,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkRed,
          side: const BorderSide(color: borderRed, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: darkRed,
        size: 24,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return lightRed;
          }
          return Colors.grey.shade700;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return Colors.grey;
        }),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkRed,
        foregroundColor: Colors.white,
      ),

      // Inside AppTheme.darkTheme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: darkRed,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final swatch = <int, Color>{};

    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (double strength in strengths) {
      final double ds = 0.5 - strength;

      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.toARGB32(), swatch);
  }
}

// Theme Controller for managing theme state
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  // Observable for theme mode
  final _isDarkMode = false.obs;

  // Getter for current theme mode
  bool get isDarkMode => _isDarkMode.value;

  // Getter for current theme data
  ThemeData get currentTheme =>
      _isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  // Method to toggle theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeTheme(currentTheme);
    update(); // Update UI
  }

  // Method to set specific theme
  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeTheme(currentTheme);
    update();
  }

  // Method to set light theme
  void setLightTheme() {
    setTheme(false);
  }

  // Method to set dark theme
  void setDarkTheme() {
    setTheme(true);
  }
}
