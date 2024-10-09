import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/api_service_base.dart';
import '../models/user_data.dart';

// Singleton: para manejar una sola instancia de FirebaseAuth.instance
class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    User? user = _auth.currentUser;
    
    await user?.reload();

    if (user != null && user.emailVerified) {
      print("El correo ha sido verificado.");
    } else {
      print("El correo aún no ha sido verificado.");
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Email de verificación enviado.");
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, 
    void Function(PhoneAuthCredential) verificationCompleted, 
    void Function(FirebaseAuthException) verificationFailed,
    void Function(String, int?) codeSent,
    void Function(String) codeAutoRetrievalTimeout,
    ) async {

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
    });
  }

  Future<void> verifyCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await currentUser?.linkWithCredential(credential).then((userCredential) {
        print('Usuario se registro con el número de teléfono: ${userCredential.user!.phoneNumber}');
        print('Número de teléfono asociado con éxito.');
      }).catchError((error) {
        print('Error al asociar el número de teléfono: $error');
      });
      
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
