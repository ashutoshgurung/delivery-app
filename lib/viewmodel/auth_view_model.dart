import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> signUp({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await _authServices.signUp(email: email, password: password);
      return user != null;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logIn({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await _authServices.logIn(email: email, password: password);
      return user != null;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    await _authServices.logOut();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password is too weak. Try a stronger one.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
