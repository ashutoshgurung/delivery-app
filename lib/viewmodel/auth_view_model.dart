import 'package:flutter/material.dart';
import 'package:food_ordering_app/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  bool isLoading = false;
  Future<bool> signUp({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authServices.signUp(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logIn({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authServices.logIn(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
