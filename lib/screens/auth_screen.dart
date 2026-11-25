import 'package:app_1/center_app.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/waiting_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _goToLogin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    await AuthServices.firebase().initialize();
    final user = AuthServices.firebase().currentUser;
    if (user == null) {
      setState(() {
        _goToLogin = true;
      });
    } else {
      _initializeUser(user);
    }
  }

  Future<void> _initializeUser(AuthUser user) async {
    final stopwatch = Stopwatch()..start();

    if (mounted) {
      await context.read<DatabaseProvider>().setUser(user);
    }
    if (mounted) {
      await context.read<DatabaseProvider>().initializeDatabase(user);
    }
    final elapsed = stopwatch.elapsedMilliseconds;
    final remainingTime = 1000 - elapsed; // Ensure minimum 1 sec
    if (remainingTime > 0) {
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_goToLogin) {
      return LoginScreen();
    }

    if (_isLoading) {
      return const WaitingScreen();
    }

    return const CenterApp();
  }
}
