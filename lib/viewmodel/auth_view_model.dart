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

<<<<<<< HEAD
  bool isLoading = false;
  String? errorMessage;

  String? _userRole;

  String? get userRole => _userRole;

  bool get isAdmin => _userRole == 'admin';
=======
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  // ================================================================
  // SIGN UP
  // ================================================================
>>>>>>> origin/main

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

<<<<<<< HEAD
=======
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

>>>>>>> origin/main
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

<<<<<<< HEAD
=======
  // ================================================================
  // EMAIL LOGIN
  // ================================================================

>>>>>>> origin/main
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

<<<<<<< HEAD
      if (user == null) {
        return false;
      }

      _userRole = await _authServices.getUserRole(user.uid);

      return true;
=======
      return user != null;
>>>>>>> origin/main
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

<<<<<<< HEAD
=======
  // ================================================================
  // GOOGLE LOGIN
  // ================================================================

>>>>>>> origin/main
  Future<bool> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authServices.signInWithGoogle();

      if (user == null) {
        return false;
      }

<<<<<<< HEAD
      _userRole = await _authServices.getUserRole(user.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      // TEMP DEBUG — remove once the real cause is found.
      debugPrint('FirebaseAuthException: code=${e.code}, message=${e.message}');
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e, stack) {
      // TEMP DEBUG — remove once the real cause is found.
      debugPrint('Google sign in error: $e');
      debugPrint('Stack: $stack');
      errorMessage = "Google sign in failed: $e";
=======
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

>>>>>>> origin/main
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

<<<<<<< HEAD
=======
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

>>>>>>> origin/main
  Future<void> logOut() async {
    await _authServices.logOut();

    _userRole = null;

    notifyListeners();
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

<<<<<<< HEAD
=======
      case 'account-exists-with-different-credential':
        return 'An account already exists using a different sign-in method.';

      case 'popup-closed-by-user':
        return 'Google sign-in was cancelled.';

>>>>>>> origin/main
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}