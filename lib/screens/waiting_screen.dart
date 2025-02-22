import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  final String title;
  const WaitingScreen({super.key, required this.title});
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
