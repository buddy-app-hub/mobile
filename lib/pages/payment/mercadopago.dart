import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile/pages/payment/failure.dart';
import 'package:mobile/pages/payment/success.dart';


class MercadoPagoScreen extends StatefulWidget {
  static const String routename ='MercadoPagoScreen';
  final String? url;
  const MercadoPagoScreen({super.key, this.url});

  @override
  State<MercadoPagoScreen> createState() => _MercadoPagoScreenState();
}

class _MercadoPagoScreenState extends State<MercadoPagoScreen> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse("${widget.url}"))),
              onUpdateVisitedHistory: (controller, url, androidIsReload){
                // print(url);
                if (url.toString().contains("https://backend.buddyapp.link/payments/success")) {
                  String? connectionId = url!.queryParameters['connection_id'];
                  String? paymentOrderId = url!.queryParameters['payment_id'];
                  // webViewController.goBack();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentSuccessPage(
                      connectionId: connectionId,
                      paymentOrderId: paymentOrderId,                      

                      )),
                  );
                  //webViewController.dispose();
                  return;
                } else if (url.toString().contains("https://backend.buddyapp.link/payments/failure")) {
                  // webViewController.goBack();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentFailurePage()),
                  );
                  // webViewController.dispose();
                  return;
                }
              },
              onWebViewCreated: (InAppWebViewController controller) {
                  webViewController = controller;
                },
              initialSettings: InAppWebViewSettings(
                userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Mobile Safari/537.36',
              ),
            )
          ],
        ),
      )
        
     
   );
  }
}