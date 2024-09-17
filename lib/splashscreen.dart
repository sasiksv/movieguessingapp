import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'StartScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Initial opacity of the image is set to 0

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation after 1 second
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0; // Fade in the background image
      });
    });

    // Navigate to the StartScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StartScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Fade-in SVG background image
            AnimatedOpacity(
              opacity: _opacity,
              duration:
                  const Duration(seconds: 2), // Duration for fade-in effect
              child: SvgPicture.asset(
                'assets/images/MG-splash.svg', // Make sure your path is correct
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
