import 'package:app_1/center_app.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/waiting_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthServices.firebase().currentUser;
    print("AuthServices User: ${user?.email}");
    if (user == null) return LoginScreen();

    return FutureBuilder(
        future: context.read<DatabaseProvider>().setUser(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return WaitingScreen(title: "awiting to set user");
          }
          return Selector<DatabaseProvider, AuthUser?>(
            selector: (_, provider) {
              print(
                  "Selector triggered with user: ${provider.currentUser?.email}");
              return provider.currentUser;
            },
            builder: (context, user1, child) {
              print("Selector rebuilt with user: ${user1?.email}");
              //INFO: authentication builder
              return FutureBuilder(
                future:
                    context.read<DatabaseProvider>().initializeDatabase(user),
                builder: (context, snapshot) {
                  print("FutureBuilder state: ${snapshot.connectionState}");
                  if (snapshot.connectionState == ConnectionState.done) {
                    print("Database Initialized");
                    return const CenterApp();
                  } else {
                    return WaitingScreen(
                      title: "Waiting for database provider initialization",
                    );
                  }
                },
              );
            },
          );
        });
  }
}
