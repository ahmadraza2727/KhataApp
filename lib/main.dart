import 'package:app_1/app.dart';
import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/screens/email_verification_screen.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/register_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(),
        ),
      ],
      child: Main(),
    ),
  );
}

class Main extends StatefulWidget {
  // const MyClass({super.key});
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            // Override all text styles
            displayLarge: TextStyle(fontFamily: "Sans"),
            displayMedium: TextStyle(fontFamily: "Sans"),
            displaySmall: TextStyle(fontFamily: "Sans"),
            headlineMedium: TextStyle(fontFamily: "Sans"),
            headlineSmall: TextStyle(fontFamily: "Sans"),
            titleLarge: TextStyle(fontFamily: "Sans"),
            titleMedium: TextStyle(fontFamily: "Sans"),
            titleSmall: TextStyle(fontFamily: "Sans"),
            bodyLarge: TextStyle(fontFamily: "Sans"),
            bodyMedium: TextStyle(fontFamily: "Sans"),
            bodySmall: TextStyle(
                fontFamily: "Sans"), // Lowercase intentional for demonstration
            labelLarge: TextStyle(fontFamily: "Sans"),
            labelSmall: TextStyle(fontFamily: "Sans"),
          ).apply(
            displayColor: Colors.black, // Default text color
            bodyColor: Colors.black,
          ),
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
      home: AuthWrapper(),
      routes: {
        home_route: (context) => AuthWrapper(),
        login_route: (context) => LoginScreen(),
        register_route: (context) => const RegisterScreen(),
        email_verification_route: (context) => const EmailVerificationScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthServices.firebase().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingScreen();
        }

        final user = AuthServices.firebase().currentUser;
        if (user == null) return LoginScreen();
        if (!user.isEmailVerified) {
          return const EmailVerificationScreen();
        }

        // DatabaseProvider will auto-update through ProxyProvider
        context.read<DatabaseProvider>().initializeDatabase(user.email!);
        return const CenterApp();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Primarycolors.primaryColor,
        ),
      ),
    );
  }
}
