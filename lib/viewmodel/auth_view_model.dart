// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:food_ordering_app/services/auth_service.dart';

// // class AuthViewModel extends ChangeNotifier {
// //   final AuthServices _authServices = AuthServices();
// //   bool isLoading = false;
// //   String? errorMessage;

// //   Future<bool> signUp({required String email, required String password}) async {
// //     isLoading = true;
// //     errorMessage = null;
// //     notifyListeners();
// //     try {
// //       final user = await _authServices.signUp(email: email, password: password);
// //       return user != null;
// //     } on FirebaseAuthException catch (e) {
// //       errorMessage = _mapAuthError(e.code);
// //       return false;
// //     } catch (e) {
// //       errorMessage = "Something went wrong. Please try again.";
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   Future<bool> logIn({required String email, required String password}) async {
// //     isLoading = true;
// //     errorMessage = null;
// //     notifyListeners();
// //     try {
// //       final user = await _authServices.logIn(email: email, password: password);
// //       return user != null;
// //     } on FirebaseAuthException catch (e) {
// //       errorMessage = _mapAuthError(e.code);
// //       return false;
// //     } catch (e) {
// //       errorMessage = "Something went wrong. Please try again.";
// //       return false;
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   Future<void> logOut() async {
// //     await _authServices.logOut();
// //   }

// //   String _mapAuthError(String code) {
// //     switch (code) {
// //       case 'user-not-found':
// //         return 'No account found with that email.';
// //       case 'wrong-password':
// //         return 'Incorrect password. Please try again.';
// //       case 'invalid-credential':
// //         return 'Invalid email or password.';
// //       case 'invalid-email':
// //         return 'That email address looks invalid.';
// //       case 'email-already-in-use':
// //         return 'An account already exists with that email.';
// //       case 'weak-password':
// //         return 'Password is too weak. Try a stronger one.';
// //       case 'too-many-requests':
// //         return 'Too many attempts. Please try again later.';
// //       case 'network-request-failed':
// //         return 'Network error. Check your connection.';
// //       default:
// //         return 'Authentication failed. Please try again.';
// //     }
// //   }
// // }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/services/auth_service.dart';

// class AuthViewModel extends ChangeNotifier {
//   final AuthServices _authServices = AuthServices();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool isLoading = false;
//   String? errorMessage;

//   Future<bool> signUp({
//     required String email,
//     required String password,
//   }) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       final user = await _authServices.signUp(
//         email: email,
//         password: password,
//       );

//       return user != null;
//     } on FirebaseAuthException catch (e) {
//       errorMessage = _mapAuthError(e.code);
//       return false;
//     } catch (e) {
//       errorMessage = "Something went wrong. Please try again.";
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> logIn({
//     required String email,
//     required String password,
//   }) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       final user = await _authServices.logIn(
//         email: email,
//         password: password,
//       );

//       return user != null;
//     } on FirebaseAuthException catch (e) {
//       errorMessage = _mapAuthError(e.code);
//       return false;
//     } catch (e) {
//       errorMessage = "Something went wrong. Please try again.";
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> signInWithGoogle() async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       final user = await _authServices.signInWithGoogle();

//       return user != null;
//     } on FirebaseAuthException catch (e) {
//       errorMessage = _mapAuthError(e.code);
//       return false;
//     } catch (e) {
//       errorMessage = "Google sign-in failed. Please try again.";
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> logOut() async {
//     await _authServices.logOut();
//   }

//   String _mapAuthError(String code) {
//     switch (code) {
//       case 'user-not-found':
//         return 'No account found with that email.';

//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';

//       case 'invalid-credential':
//         return 'Invalid email or password.';

//       case 'invalid-email':
//         return 'That email address looks invalid.';

//       case 'email-already-in-use':
//         return 'An account already exists with that email.';

//       case 'weak-password':
//         return 'Password is too weak. Try a stronger one.';

//       case 'too-many-requests':
//         return 'Too many attempts. Please try again later.';

//       case 'network-request-failed':
//         return 'Network error. Check your connection.';

//       case 'account-exists-with-different-credential':
//         return 'An account already exists using a different sign-in method.';

//       case 'popup-closed-by-user':
//         return 'Google sign-in was cancelled.';

//       default:
//         return 'Authentication failed. Please try again.';
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  // ================================================================
  // SIGN UP
  // ================================================================

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authServices.signUp(
        email: email,
        password: password,
      );

      if (user != null) {
        // Create customer document
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({
          'name': user.displayName ?? '',
          'email': user.email ?? email,
          'imageUrl': user.photoURL ?? '',
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

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

  // ================================================================
  // EMAIL LOGIN
  // ================================================================

  Future<bool> logIn({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authServices.logIn(
        email: email,
        password: password,
      );

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

  // ================================================================
  // GOOGLE LOGIN
  // ================================================================

  Future<bool> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authServices.signInWithGoogle();

      if (user == null) {
        return false;
      }

      final userRef =
          _firestore.collection('users').doc(user.uid);

      final userDoc = await userRef.get();

      // ------------------------------------------------------------
      // NEW GOOGLE USER
      // ------------------------------------------------------------

      if (!userDoc.exists) {
        await userRef.set({
          'name': user.displayName ?? 'Customer',
          'email': user.email ?? '',
          'imageUrl': user.photoURL ?? '',
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');

      errorMessage =
          "Google sign-in failed. Please try again.";

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================================================
  // GET CURRENT USER ROLE
  // ================================================================

  Future<String> getCurrentUserRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'customer';
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      return 'customer';
    }

    final data = doc.data();

    return data?['role'] ?? 'customer';
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> logOut() async {
    await _authServices.logOut();
  }

  // ================================================================
  // ERROR HANDLING
  // ================================================================

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

      case 'account-exists-with-different-credential':
        return 'An account already exists using a different sign-in method.';

      case 'popup-closed-by-user':
        return 'Google sign-in was cancelled.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}