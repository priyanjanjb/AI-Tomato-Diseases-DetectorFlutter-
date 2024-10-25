// ignore_for_file: file_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tmtdiseases/homePage.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            // Use Expanded or Flexible to fit the widgets within available space
            const Expanded(
              child: Image(
                image: AssetImage(
                  "assets/image/logo/_Green Simple Nature Beauty Care Initials Logo  (1).png",
                ),
              ),
            ),

            Expanded(
              child: LottieBuilder.asset(
                'assets/animation/Animation - 1726379697327.json',
                width: 204,
              ),
            ),
          ],
        ),
        nextScreen: const Homepage(),
        duration: 1000, // 16 seconds duration as you want
      ),
    );
  }
}
