import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MeetingCodeVerification extends StatefulWidget {
  final Function(String) onCompleted;

  MeetingCodeVerification({required this.onCompleted});

  @override
  State<MeetingCodeVerification> createState() =>
      _MeetingCodeVerificationState();
}

class _MeetingCodeVerificationState extends State<MeetingCodeVerification> {
  late FocusNode _pinFocusNode;

  @override
  void initState() {
    super.initState();
    _pinFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      textStyle: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary),
    );

    return Pinput(
        length: 6,
        focusNode: _pinFocusNode,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        onCompleted: widget.onCompleted);
  }
}

void verifyCode(String code) async {
  print("Código ingresado: $code");
}
