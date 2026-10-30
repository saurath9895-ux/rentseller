import '../services/authservice.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<String> signUp(String email, String password, String name, String phone) async {
    return await _authService.createUserWithEmail(email, password, name, phone);
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> signOut() async {
    await _authService.logOut();
  }
}