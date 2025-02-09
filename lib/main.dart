import 'package:app_1/app.dart';
import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/firebase_options.dart';
import 'package:app_1/provider.dart';
import 'package:app_1/screens/email_verification_screen.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/register_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart' show Firebase;

void main() {
  // Set status bar color and text color
  runApp(ChangeNotifierProvider(
    create: (context) => CounterProvider(),
    child: Main(),
  ));
}

class Main extends StatelessWidget {
  // const MyClass({super.key});
  const Main({super.key});

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
          fontFamily: "Sans",
          colorScheme: ColorScheme.fromSeed(
            seedColor: Primarycolors.primaryColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Primarycolors.primaryColor,
              textStyle: TextStyle(color: Primarycolors.textDark),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
// FutureBuilder(
//         future: AuthServices.firebase().initialize(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               final AuthUser? user = AuthServices.firebase().currentUser;
//               if (user != null) {
//                 if (user.isEmailVerified) {
//                   return LoginScreen();
//                 } else {
//                   return HomeScreen();
//                 }
//               }
//               else{
//               return LoginScreen();
//               }
//
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//             case ConnectionState.active:
//               throw UnimplementedError();
//           }

      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final AuthUser? user = AuthServices.firebase().currentUser;
                  if (user != null) {
                    if (user.isEmailVerified) {
                      return CenterApp();
                    } else {
                      return CenterApp();
                    }
                  } else {
                    return CenterApp();
                    // return LoginScreen();
                    // return CenterApp();
                  }

                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: CircularProgressIndicator(),
                  );
              }
            }),
      ),
      routes: {
        home_route: (context) => const Main(),
        // "/transactions/": (context) => const TransactionScreen(),
        // "/calender/": (context) => const CalenderScreen(),
        // "/poeple/": (context) => const PeopleScreen(),
        // "/inform/": (context) => const InformScreen(),
        login_route: (context) => LoginScreen(),
        register_route: (context) => RegisterScreen(),
        email_verification_route: (context) => EmailVerificationScreen(),
      },
    );
  }
}
