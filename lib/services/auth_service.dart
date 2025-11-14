import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseInAppMessaging _firebaseInAppMessaging;

  AuthService(this._firebaseAuth) : _firebaseInAppMessaging = FirebaseInAppMessaging.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _firebaseInAppMessaging.triggerEvent('user_logged_in');
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _firebaseInAppMessaging.triggerEvent('user_logged_in');
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
