import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_data.dart';

// Singleton: para manejar una sola instancia de FirebaseAuth.instance
class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _verificationId = '';

  factory AuthService() {
    return _instance;
  }
  AuthService._internal();

  User? get currentUser => _auth.currentUser;

  Future<UserData> fetchUserData() async {
    var response = await ApiService.get<dynamic>(
      endpoint: "/users/me",
    );
    print(response);

    return UserData.fromJson(response);
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await sendEmailVerification();
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    await user?.reload();

    if (user != null && user.emailVerified) {
      print("El correo ha sido verificado.");
    } else {
      print("El correo aún no ha sido verificado.");
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Email de verificación enviado.");
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout: $verificationId');
        },
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }

  Future<void> verifyCode(String smsCode) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('Verification successful: ${userCredential.user?.uid}');
    } catch (e) {
      print('Error verifying code: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }
}
