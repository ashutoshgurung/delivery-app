import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  late final Future<void> _googleSignInInitialization =
      _googleSignIn.initialize();

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
    await _googleSignInInitialization;

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

  Future<String> getUserRole(String uid) async {
    final document =
        await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return 'user';
    }

    final data = document.data();

    return data?['role'] ?? 'user';
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}