import 'package:flutter/material.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'dart:async';

class CreateReauthenticationModal extends StatefulWidget {
  final Future<void> Function(String email, String password) onDoneModal;

  const CreateReauthenticationModal({
    super.key,
    required this.onDoneModal,
  });

  @override
  State<CreateReauthenticationModal> createState() =>
      _CreateReauthenticationModalState();
}

class _CreateReauthenticationModalState
    extends State<CreateReauthenticationModal> {
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
        // Navigator.of(context)
        // .pushNamedAndRemoveUntil(home_route, (route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Authenticate",
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
                      'Verify Your Account',
                      // style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Verify To Delete your Account',
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
                    SizedBox(height: 16),
                    // INFO : register button
                    ElevatedButton(
                      onPressed: () {
                        widget.onDoneModal(
                            _passwordController.text, _emailController.text);
                      },
                      child: Text('Confirm'),
                    ),
                    SizedBox(height: 16),
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
