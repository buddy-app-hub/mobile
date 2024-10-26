import 'package:flutter/material.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/pages/auth/splash_screen.dart';
import 'package:mobile/pages/home/for_you/for_you.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/widgets/ongoing_meeting_card.dart';
import 'package:pinput/pinput.dart';

class MeetingCodeVerification extends StatefulWidget {
  final Meeting meeting;

  MeetingCodeVerification({required this.meeting});

  @override
  _MeetingCodeVerificationState createState() =>
      _MeetingCodeVerificationState();
}

class _MeetingCodeVerificationState extends State<MeetingCodeVerification> {
  String? errorMessage;
  FocusNode _focusNode = FocusNode();
  TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleCodeSubmission(String code) async {
    final theme = Theme.of(context);
    bool meetingStarted = await verifyCode(context, code, widget.meeting);
    if (meetingStarted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Encuentro comenzado!",
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } else {
      setState(() {
        errorMessage = "El código es incorrecto";
      });

      _pinController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pinput(
          length: 6,
          focusNode: _focusNode,
          controller: _pinController,
          defaultPinTheme: defaultPinTheme,
          onCompleted: _handleCodeSubmission,
        ),
        if (errorMessage != null) ...[
          SizedBox(height: 8),
          Text(
            errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ],
    );
  }
}

Future<bool> verifyCode(
    BuildContext context, String inputCode, Meeting meeting) async {
  final connectionService = ConnectionService();

  String trueCode = generateCode(meeting);
  if (inputCode == trueCode) {
    print("El código $inputCode ingresado es válido");

    meeting.startConfirmed = true;

    try {
      await connectionService.updateMeetingOfConnection(
          context, meeting.connection!, meeting);
    } catch (e) {
      print("Error actualizando comienzo de encuentro: $e");
      return false;
    }
    return true;
  }
  return false;
}
