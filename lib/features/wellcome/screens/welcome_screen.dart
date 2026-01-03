import '../controller/welcome_controller.dart';
import '/app_importer.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(WelcomeController());
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: appGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 175,
              color: Colors.white,
            ),
            Text(
              appName,
              style: xxLargeBoldText.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
