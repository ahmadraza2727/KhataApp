import 'package:app_1/services/auth/auth_provider.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:app_1/services/auth/firebase_auth_provider.dart';

class AuthServices extends AuthProvider {
  final AuthProvider provider;

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  AuthServices({required this.provider});
  factory AuthServices.firebase() =>
      AuthServices(provider: FirebaseAuthProvider());

  @override
  Future<AuthUser> createUer(
          {required String email, required String password}) =>
      provider.createUer(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
