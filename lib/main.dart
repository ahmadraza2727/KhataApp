import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/screens/auth_screen.dart';
import 'package:app_1/screens/email_verification_screen.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/register_screen.dart';
import 'package:app_1/screens/waiting_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    try {
      // debugPrint("-----------------WorkManager Task Executed: $task");

      if (task == "task") {
        // debugPrint("----------Executing due date notifications task...");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userEmail = prefs.getString(user_email_preference);

        if (userEmail != null) {
          // debugPrint(
          // "-------------Email found: $userEmail - Sending notifications");
          await NotificationService().showDueNotifications(userEmail);
          return Future.value(true);
        } else {
          // debugPrint("-----------------No email found in SharedPreferences");
          return Future.value(false);
        }
      }

      // debugPrint("------------Unknown task: $task");
      return Future.value(false);
    } catch (e) {
      // debugPrint(" Error in WorkManager task: $e");
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async main

  Workmanager().cancelAll();

  await NotificationService().init();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in release mode
  );

  // print("WorkManager Initialized");
  Workmanager().registerPeriodicTask(
    "task",
    "task",
    initialDelay: Duration(seconds: 10),
    frequency: Duration(days: 1),
  );

  // print("Task Registered");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DatabaseProvider(nprovider: context.read<NavigationProvider>()),
        ),
      ],
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  // const MyClass({super.key});
  const Main({super.key});

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

            displayLarge:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            displayMedium:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            displaySmall:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            headlineMedium:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            headlineSmall:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            titleLarge:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            titleMedium:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            titleSmall:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            bodyLarge:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            bodyMedium:
                TextStyle(fontFamily: "Sans", color: Primarycolors.textDark),
            bodySmall: TextStyle(
                fontFamily: "Sans",
                color: Primarycolors
                    .textDark), // Lowercase intentional for demonstration
            labelLarge: TextStyle(
                fontFamily: "Sans",
                color: Primarycolors
                    .textDark), // Lowercase intentional for demonstration
            labelSmall: TextStyle(
                fontFamily: "Sans",
                color: Primarycolors
                    .textDark), // Lowercase intentional for demonstration
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
      home: FutureBuilder(
          future: AuthServices.firebase().initialize(),
          builder: (context, snapshot) {
            // print("listening for firestore updates $userEmail and id $userId");
            // if (userId != null && userEmail != null) {
            // }
            if (snapshot.connectionState != ConnectionState.done) {
              return const WaitingScreen(
                title: "waiting for firebase initialization",
              );
            }

            // LocalKhataDatabaseServices db = LocalKhataDatabaseServices();
            // listenForCloudTransactions(
            //   AuthServices.firebase().currentUser!.email,
            //   AuthServices.firebase().currentUser!.uid.toString(),
            //   db,
            // );
            return AuthWrapper();
          }),
      routes: {
        home_route: (context) => AuthWrapper(),
        login_route: (context) => LoginScreen(),
        register_route: (context) => const RegisterScreen(),
        email_verification_route: (context) => const EmailVerificationScreen(),
      },
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthServices.firebase().initialize(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const WaitingScreen(
//             title: "waiting for database initialization",
//           );
//         }
//
//         final user = AuthServices.firebase().currentUser;
//         if (user == null) return LoginScreen();
//
// TODOo: do something with email verification
//
//         // if (!user.isEmailVerified) {
//         // return const EmailVerificationScreen();
//         // }
//
//         // DatabaseProvider will auto-update through ProxyProvider
//         return FutureBuilder(
//             future: context.read<DatabaseProvider>().initializeDatabase(user),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.done:
//                   return const CenterApp();
//                 default:
//                   return WaitingScreen(
//                     title: "waiting for databaase provider initialization",
//                   );
//               }
//             });
//       },
//     );
//   }
// }

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
