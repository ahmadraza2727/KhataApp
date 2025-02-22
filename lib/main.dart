import 'package:app_1/app.dart';
import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/providers/navigation_provider.dart';
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
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "send_due_date_notifications":
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userEmail = prefs.getString(user_email_preference);

        if (userEmail != null) {
          await NotificationService().showDueNotifications(userEmail);
        }
        break;
      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init(); // Initialize notifications

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "check_due_dates", // unique name
    "send_due_date_notifications", // task name
    frequency: const Duration(
      minutes: 5,
    ),
  );
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
          return const WaitingScreen(
            title: "waiting for database initialization",
          );
        }

        final user = AuthServices.firebase().currentUser;
        if (user == null) return LoginScreen();

        //TODO: do something with email verification

        // if (!user.isEmailVerified) {
        // return const EmailVerificationScreen();
        // }

        // DatabaseProvider will auto-update through ProxyProvider
        return FutureBuilder(
            future: context
                .read<DatabaseProvider>()
                .initializeDatabase(user.email!),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return const CenterApp();
                  break;
                default:
                  return WaitingScreen(
                    title: "waiting for databaase provider initialization",
                  );
              }
            });
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
