import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/services/auth_service.dart';
import '../../../models/user_data.dart';

class AuthSessionProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  UserData? _userData;

  AuthSessionProvider(this._authService) {
    _user = _authService.currentUser;
    if (_user != null) {
      fetchUserData();
    }
  }

  User? get user => _user;
  UserData? get userData => _userData;
  bool get isAuthenticated =>
      _user != null && (_userData?.buddy != null || _userData?.elder != null);
  bool get isBuddy => _user != null && (_userData?.buddy != null);
  bool get isElder => _user != null && (_userData?.elder != null);
  PersonalData get personalData =>
      isBuddy ? _userData!.buddy!.personalData : _userData!.elder!.personalData;

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

  Future<void> sendCode({
    required String phone,
    required Function(PhoneAuthCredential) verificationCompleted, 
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required  Function(String) codeAutoRetrievalTimeout,}) async {
      
    await _authService.verifyPhoneNumber(phone, verificationCompleted, verificationFailed, codeSent, codeAutoRetrievalTimeout);
    notifyListeners();
  }

  Future<void> verifyCode(String verificationId, String smsCode) async {
    await _authService.verifyCode(verificationId, smsCode);
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    _userData = await _authService.fetchUserData();
    notifyListeners();
  }
}
