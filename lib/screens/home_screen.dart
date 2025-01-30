import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("this is text ois"),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 150,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
        SizedBox(height: 20),
        Placeholder(
          fallbackHeight: 100,
        ),
      ],
    );
  }
}
