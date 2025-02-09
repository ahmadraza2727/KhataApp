import 'dart:async';

import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

// class EmailVerificationScreen extends StatelessWidget {
//   const EmailVerificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: VerificationCard(),
//         ),
//       ),
//     );
//   }
// }

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResend = false;
  int timer = 10;
  Timer? countdownTimer;

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        setState(() => this.timer--);
      } else {
        setState(() => isResend = true);
        countdownTimer?.cancel();
      }
    });
  }

  void sendVerification() async {
    setState(() {
      isResend = false;
      timer = 10;
    });
    await AuthServices.firebase().sendEmailVerification();
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(home_route, (route) => false);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Primarycolors.primaryColor,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Primarycolors.darkColor,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email Verification Required",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Verification helps secure your account and enables cloud backup for your data.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isResend ? sendVerification : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isResend
                            ? Primarycolors.darkColor
                            : Primarycolors.secondaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isResend ? "Resend Verification" : "Wait (${timer}s)",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
