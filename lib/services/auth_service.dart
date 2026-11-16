import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/strings.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<String?> signUp(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user?.updateDisplayName(name.trim());
      await cred.user?.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return _msg(e.code);
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _msg(e.code);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      if (kIsWeb) {
        await _auth.signInWithPopup(provider);
      } else {
        await _auth.signInWithProvider(provider);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return null;
      }
      return _msg(e.code);
    }
  }

  Future<void> logout() => _auth.signOut();

  String _msg(String code) {
    switch (code) {
      case 'invalid-email':
        return tr('That email address is not valid.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return tr('Incorrect email or password.');
      case 'email-already-in-use':
        return tr('An account with this email already exists.');
      case 'weak-password':
        return tr('Password must be at least 6 characters.');
      case 'popup-blocked':
        return tr(
          'Your browser blocked the sign-in popup. Please allow popups and try again.',
        );
      case 'too-many-requests':
        return tr('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return tr('Network error. Check your internet connection.');
      default:
        return tr('Something went wrong ({code}). Please try again.', {
          'code': code,
        });
    }
  }
}
