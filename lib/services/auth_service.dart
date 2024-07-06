import 'package:firebase_auth/firebase_auth.dart';

// Singleton: para manejar una sola instancia de FirebaseAuth.instance
class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthService() {
    return _instance;
  }
  AuthService._internal();

  User? get currentUser => _auth.currentUser;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async { await _auth.signOut(); }

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }
}