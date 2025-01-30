import 'package:app_1/app.dart';
import 'package:app_1/colors/primary_colors.dart';
import 'package:app_1/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // Set status bar color and text color
  runApp(ChangeNotifierProvider(
    create: (context) => CounterProvider(),
    child: MyClass(),
  ));
}

class MyClass extends StatelessWidget {
  // const MyClass({super.key});
  const MyClass({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar background
      statusBarIconBrightness:
          Brightness.dark, // Dark icons/text for white background
      statusBarBrightness:
          Brightness.light, // For iOS: light background for dark text
    ));
    return MaterialApp(
      // color: Color.fromARGB(255, 0, 255, 0),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Primarycolors.primaryColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            // hintText: "Enter something...",
            hintStyle: TextStyle(
              color: Primarycolors.textLight, // Light text for placeholder
              fontSize: 16,
            ),
            filled: true, // Background color
            fillColor: Primarycolors.primaryColor, // Light blue background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Smooth rounded corners
              borderSide: BorderSide(
                color: Primarycolors.secondaryColor, // Subtle border
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Primarycolors.secondaryColor, // Border for idle state
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Primarycolors.darkColor, // Border for focused state
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ), // Inner padding for text
          )),
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CenterApp(),
      ),
    );
  }
}
