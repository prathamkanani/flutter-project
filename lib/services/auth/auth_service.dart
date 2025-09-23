import 'package:demo_project/services/auth/auth_provider.dart';
import 'package:demo_project/services/auth/auth_user.dart';
import 'package:demo_project/services/auth/firebase_auth_provider.dart';

/// Auth Service is dependent on Auth Provider so,
/// Auth Service is not making assumption that its always Firebase
/// instead it provides factory for firebase (using dependency injection).

/// DEPENDENCY INJECTION
/// Auth service is dependent on a provider using a constant
/// constructor initializer we are injecting the provider into it.

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
