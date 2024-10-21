import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/choose_user.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';


class VerifyPhoneCodePage extends StatefulWidget {
  const VerifyPhoneCodePage({super.key, required this.countryCode, required this.phone, required this.verificationId, this.forceResendingToken});

  final String countryCode;
  final String phone;
  final String verificationId;
  final int? forceResendingToken;

  @override
  State<VerifyPhoneCodePage> createState() => _VerifyPhoneCodePageState();
}

class _VerifyPhoneCodePageState extends State<VerifyPhoneCodePage> {
  Timer? timer;

  int timeUntilNextResend = Duration.secondsPerMinute;
  late FocusNode _pinFocusNode;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (timeUntilNextResend < 1) {
        timer.cancel();
      } else if (mounted) {
        setState(() {
          timeUntilNextResend--;
        });
      }
    });
  }

  Future<void> resendOtp() async {
    AuthSessionProvider authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    authProvider.sendCode(
      phone: widget.phone, 
      verificationCompleted: (phoneAuthCredential) async {
        final smsCode = phoneAuthCredential.smsCode;
        print("Verification completed $smsCode");
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(SnackBar(content: Text("${error.message}")));
      },
      codeSent: (verificationId, x) {
        if (widget.forceResendingToken == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhoneCodePage(
                countryCode: widget.countryCode,
                phone: widget.phone,
                verificationId: verificationId,
                forceResendingToken: x,
              ),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _pinFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainer),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(28, 60, 28, 10),
                child: Text(
                  'Verificación',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ingrese el código PIN enviado a su teléfono',
                      style: ThemeTextStyle.titleSmallOutline(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Pinput(
                length: 6,
                focusNode: _pinFocusNode, 
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                onCompleted: (value) {
                  verifyOtp(
                    countryCode: widget.countryCode,
                    phone: widget.phone,
                    context: context,
                    otp: value,
                    verificationId: widget.verificationId,
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: timeUntilNextResend == 0 ? resendOtp : null,
                child: Text(timeUntilNextResend == 0
                    ? "Reenviar código otra vez"
                    : "Se reenviara el código en 00:${timeUntilNextResend.toString().padLeft(2, '0')}"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> verifyOtp(
      {required BuildContext context, required String countryCode, required String phone, required String otp, required String verificationId}) async {
    try {
      AuthSessionProvider authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
  
      await authProvider.verifyCode(verificationId, otp);
      if (!context.mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseUserPage(countryCode: countryCode, phone: phone,),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("${e.toString()}")));
    } finally {
      // context.loaderOverlay.hide();
    }
  }
}