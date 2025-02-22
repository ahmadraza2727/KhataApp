import 'package:app_1/center_app.dart';
import 'package:app_1/main.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/waiting_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
