import 'package:flutter/material.dart';
import 'package:mymovie/routes/app_observers.dart';
import 'package:mymovie/theme/app_theme.dart';
import 'app_importer.dart';
import 'general_bindings.dart';
import 'routes/app_pages.dart';

void main() {
  // Initialize bindings BEFORE runApp
  WidgetsFlutterBinding.ensureInitialized();
  GeneralBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        // Remove initialBinding since we already initialized
        navigatorObservers: [AppRouteObservers()],
        getPages: AppRoutePages.getPages,
        initialRoute: AppRoutes.start,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,

        // Performance optimizations
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        smartManagement: SmartManagement.keepFactory,
      ),
    );
  }
}


