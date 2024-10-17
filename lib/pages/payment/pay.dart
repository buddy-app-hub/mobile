import 'package:flutter/material.dart';
import 'package:mobile/models/payment_handshake.dart';
import 'package:mobile/pages/payment/mercadopago.dart';
import 'package:mobile/services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentService paymentService = PaymentService();
  String _preferenceUrl = '';

  @override
  void initState() {
    super.initState();
    _loadPreferenceUrl();
  }

  Future<void> _loadPreferenceUrl() async {
    PaymentHandshake? payment = await paymentService.getHandshake("123");

    setState(() {
      _preferenceUrl = payment.sandboxInitPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagar'),
        ),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MercadoPagoScreen(
                                  url: _preferenceUrl,
                                )));
                  }
                },
                child: const Text('Pagar con MercadoPago'))));
  }
}
