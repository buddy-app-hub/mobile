import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/auth_service.dart';

class AuthSessionProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  Map<String, dynamic>? _userData;

  AuthSessionProvider(this._authService) {
    _user = _authService.currentUser;
    if (_user != null) {
      fetchUserData();
    }
  }

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _user != null && _userData != null;

  Future<User?> registerWithEmail(String email, String password) async {
    _user = await _authService.createUserWithEmailAndPassword(email, password);
    notifyListeners();
    return user;
  }

Future<User?> signInWithEmail(String email, String password) async {
    _user = await _authService.signInWithEmail(email, password);
    if (_user != null) {
      await fetchUserData();
    }
    notifyListeners();
    return _user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userData = null;
    notifyListeners();
  }

   Future<void> fetchUserData() async {
    _userData = await _authService.fetchUserData();
    notifyListeners();
  }

}