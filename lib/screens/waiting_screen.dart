import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/waiting.json', // Path to your Lottie file
          width: 200,
          height: 200,
          repeat: true, // Ensure looping
          animate: true, // Make sure it animates
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
