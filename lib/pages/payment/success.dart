import 'package:flutter/material.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/splash_screen.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String? connectionId;
  final String? meetingId;
  final String? paymentOrderId;

  const PaymentSuccessPage({super.key, this.connectionId, this.meetingId, this.paymentOrderId});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  final PaymentService paymentService = PaymentService();
  final ConnectionService connectionService = ConnectionService();
  final BuddyService buddyService = BuddyService();
  bool finishedSavingTx = false;

  @override
  void initState() {
    super.initState();
    _saveTransaction();
  }

  Future<void> _saveTransaction() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    if (!authProvider.isAuthenticated || authProvider.isBuddy) {
      return;
    }

    if (widget.connectionId == null || widget.paymentOrderId == null) {
      return;
    }

    try {
      Connection connection = await connectionService.getConnection(widget.connectionId!);
      Buddy buddy = await buddyService.getBuddy(connection.buddyID);
      await paymentService.create(
          authProvider.userData!.elder!.personalData.firstName,
          buddy.walletId!,
          widget.paymentOrderId!,
          widget.connectionId!,
        );
      
      Meeting meeting = connection.meetings.firstWhere((m) => m.meetingID == widget.meetingId);
      meeting.isConfirmedByElder = true;
      meeting.isPaymentPending = false;
      print("Aca en success");
      await connectionService.updateMeetingOfConnection(context, connection, meeting);
      setState(() {
        finishedSavingTx = true;
      });
    } catch (e) {
      print(e);
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Realizado'),
      ),
      body: Center(
        child: 
        finishedSavingTx ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            Text(
              'Tu pago se realizó correctamente!',
              style: TextStyle(fontSize: 20),
            ),
            BaseElevatedButton(
              onPressed: () {
                if(context.mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
                }
              },
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              buttonStyle: ThemeButtonStyle.secondaryButtonStyle(context),
              buttonTextStyle: ThemeTextStyle.titleLargeOnPrimary(context),
              text: 'Volver al home',
          )
          ],
        ) : CircularProgressIndicator(),
      ),
    );
  }
}