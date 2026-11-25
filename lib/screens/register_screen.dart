import 'package:app_1/components/dialogs.dart';
import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/services/auth/auth_exceptions.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleRegisteration() async {}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorText;
  void handleRegisteration() async {
    if (_formKey.currentState!.validate()) {
      // Perform registration action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registering...'),
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final user = await AuthServices.firebase().createUer(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
        prefs.setString(user_email_preference, user.email.toString());
        prefs.setString(user_id_preference, user.uid.toString());
        prefs.setBool(user_logged_in_preference, true);

        if (!mounted) return;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(login_route, (route) => false);
      } on EmailAlreadyInUseAuthException {
        errorText = "Email Already In Use";
        // print("--------------------user already in use ");
        // rethrow;
      } on WeakPasswordAuthException {
        errorText = "Weak Password";
        // print("--------------------weak password");
        // rethrow;
      } on InvalidEmailAuthException {
        errorText = "Invalid Email";
        // print("--------------------invalid email");
        // rethrow;
      } catch (e) {
        // print(e.toString());
        if (!mounted) return;
        showErrorDialog(context, e.toString());
        // rethrow;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return; // If already popped, do nothing

        // Navigate to another screen instead of closing the app
        Navigator.of(context)
            .pushNamedAndRemoveUntil(home_route, (route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(home_route, (route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Register",
            style: TextStyle(
              color: Primarycolors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      // style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      // style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon:
                            Icon(Icons.person, color: Primarycolors.textLight),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email, color: Primarycolors.textLight),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock, color: Primarycolors.textLight),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon:
                            Icon(Icons.lock, color: Primarycolors.textLight),
                        errorText: errorText,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    // INFO : register button
                    ElevatedButton(
                      onPressed: handleRegisteration,
                      child: Text('Register'),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            login_route, (route) => false);
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Primarycolors.textLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
