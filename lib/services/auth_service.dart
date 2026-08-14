// import 'package:firebase_auth/firebase_auth.dart';

// class AuthServices {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signUp({
//     required String email,
//     required String password,
//   }) async {
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return userCredential.user;
//   }

//   Future<User?> logIn({required String email, required String password}) async {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     return userCredential.user;
//   }

//   Future<void> logOut() async {
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User?> logIn({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User?> signInWithGoogle() async {
    await _googleSignIn.initialize();

    final GoogleSignInAccount googleUser =
        await _googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<void> logOut() async {
    await _auth.signOut();

    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}