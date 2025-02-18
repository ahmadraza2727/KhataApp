import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
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
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Container for Sliding Effect
        Consumer<NavigationProvider>(
          builder: (context, provider, child) => AnimatedContainer(
            duration: Duration(seconds: 1), // Animation duration
            height: provider.searchTextFeildOpenStatus
                ? 60
                : 0, // Height changes to make it appear/disappear
            curve: Curves.fastOutSlowIn, // Smooth animation curve
            child: provider.searchTextFeildOpenStatus
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        print("User typed: $value");
                        print("the value of controller is ${_controller.text}");
                        dbProvider.Search(value.toString());
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search",
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.cancel, color: Colors.grey),
                                onPressed: () {
                                  _controller.clear();

                                  dbProvider.Search("");
                                  setState(() {});
                                  // setState(() {}); // Update UI
                                },
                              )
                            : null,
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
        ),
      ],
    );
  }
}
