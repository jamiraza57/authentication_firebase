import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String?> signUp({required String email, required String password, String? name}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (name != null && name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
        await cred.user?.reload();
      }
      // send verification
      await cred.user?.sendEmailVerification();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendEmailVerification() async {
    try {
      final u = _auth.currentUser;
      if (u != null && !u.emailVerified) {
        await u.sendEmailVerification();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> refreshAndCheckVerified() async {
    final u = _auth.currentUser;
    if (u == null) return false;
    await u.reload();
    return u.emailVerified;
  }

  // Google Sign-In
  // Future<String?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return 'Cancelled';
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //     notifyListeners();
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
}