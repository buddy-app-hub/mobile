import 'package:flutter/material.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/widgets/ongoing_meeting_card.dart';
import 'package:pinput/pinput.dart';

final connectionService = ConnectionService();

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

Future<bool> verifyCode(BuildContext context, String inputCode, Meeting meeting) async {
  String trueCode = generateCode(meeting);
  if (inputCode == trueCode) {
    print("El código $inputCode ingresado es válido");

    meeting.startConfirmed = true;

    try {
      await connectionService.updateMeetingOfConnection(context, meeting.connection!, meeting);
    } catch (e) {
      print("Error actualizando comienzo de encuentro: $e");
      return false;
    }
    return true;
  }
  return false;
}
