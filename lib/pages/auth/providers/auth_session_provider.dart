import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/auth_service.dart';

class AuthSessionProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;

  AuthSessionProvider(this._authService) {
    _user = _authService.currentUser;
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<User?> registerWithEmail(String email, String password) async {
    _user = await _authService.createUserWithEmailAndPassword(email, password);
    notifyListeners();
    return user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    _user = await _authService.signInWithEmail(email, password);
    notifyListeners();
    return _user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}