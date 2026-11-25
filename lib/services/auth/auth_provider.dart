import 'package:app_1/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialize();
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUer({
    required String email,
    required String password,
    required String name,
  });
  Future<bool> deleteUser({
    required String email,
    required String password,
  });
  Future<void> updateDisplayName(String name);
  Future<void> logout();
  Future<void> sendEmailVerification();
}
