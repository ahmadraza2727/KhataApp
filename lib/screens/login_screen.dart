import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/services/auth/auth_exceptions.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

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
          // INFO : back button on app bar
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(home_route, (route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Login",
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
                      'Welcome Back',
                      // style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Login to your account',
                      // style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
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
                    SizedBox(height: 24),
                    // INFO : login button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Perform registration action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('logging in...'),
                            ),
                          );
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          try {
                            final user = await AuthServices.firebase().login(
                                email: _emailController.text,
                                password: _passwordController.text);

                            //INFO: setuser in shared prefrences
                            prefs.setString(
                                user_email_preference, user.email.toString());

                            prefs.setBool(user_logged_in_preference, true);

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                home_route, (route) => false);
                          } on WrongPasswordAuthException {
                            prefs.remove(user_email_preference);
                            prefs.setBool(user_logged_in_preference, false);
                            print("wrong password");
                            rethrow;
                          } on UserNotFoundAuthException {
                            prefs.remove(user_email_preference);
                            prefs.setBool(user_logged_in_preference, false);
                            print("user not found");
                            rethrow;
                          } on UserNotLoggedInAuthException {
                            prefs.remove(user_email_preference);
                            prefs.setBool(user_logged_in_preference, false);
                            print("user not logged in");
                            rethrow;
                          } on GenericAuthException {
                            prefs.remove(user_email_preference);
                            prefs.setBool(user_logged_in_preference, false);
                            print("generic exception");
                            rethrow;
                          } catch (e) {
                            prefs.remove(user_email_preference);
                            prefs.setBool(user_logged_in_preference, false);
                            print(e.toString());
                            rethrow;
                          }
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            register_route, (route) => false);
                      },
                      child: Text(
                        'Don\'t have an account? Sign up',
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
