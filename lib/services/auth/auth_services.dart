import 'package:app_1/services/auth/auth_provider.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:app_1/services/auth/firebase_auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices extends AuthProvider {
  final AuthProvider provider;

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<void> updateDisplayName(String name) =>
      provider.updateDisplayName(name);
  // private constructor
  AuthServices.instance({required this.provider});
  static get instanceFirebase =>
      AuthServices.instance(provider: FirebaseAuthProvider());
  factory AuthServices.firebase() => instanceFirebase;

  @override
  Future<AuthUser> createUer({
    required String email,
    required String password,
    required String name,
  }) =>
      provider.createUer(email: email, password: password, name: name);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
