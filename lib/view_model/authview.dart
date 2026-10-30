import 'package:flutter/material.dart';
import '../repository/authrepository.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  final AuthRepository _repository = AuthRepository();

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = await _repository.signUp(email, password, name, phone);
      isLoading = false;
      notifyListeners();
      return uid;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Sign Up Error: $e");
      return null;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.signIn(email, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Sign In Error: $e");
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.resetPassword(email);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Password Reset Error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.signOut();
    } catch (e) {
      print("Sign Out Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}