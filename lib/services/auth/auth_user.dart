import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final int uid;
  final String email;
  final String name;
  final bool isEmailVerified;
  AuthUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.isEmailVerified,
  });
  AuthUser.fromFirebaseUser(User user)
      : email = user.email as String,
        isEmailVerified = user.emailVerified,
        name = user.displayName ?? "",
        uid = int.tryParse(user.uid) ?? 0;
}
