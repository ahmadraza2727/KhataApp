import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFeild extends StatefulWidget {
  const SearchFeild({super.key});

  @override
  State<SearchFeild> createState() => _SearchFeildState();
}

class _SearchFeildState extends State<SearchFeild> {
  // bool _isVisible = false; // Controls the visibility of the input field

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Container for Sliding Effect
        AnimatedContainer(
          duration: Duration(seconds: 1), // Animation duration
          height: provider.searchTextFeildOpenStatus
              ? 60
              : 0, // Height changes to make it appear/disappear
          curve: Curves.fastOutSlowIn, // Smooth animation curve
          child: provider.searchTextFeildOpenStatus
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: "Search",
                      // hintText: "Enter something...",
                    ),
                    style: TextStyle(
                      color: Primarycolors.textDark, // Dark text for input
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null, // When not visible, set child to null
        ),
      ],
    );
  }
}
