import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile/models/payment_handshake.dart';
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
    PaymentHandshake? payment =
        await paymentService.getHandshake();

    setState(() {
      _preferenceUrl = payment.initPoint;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Pagar con MercadoPago'),
          onPressed: () => _launchURL(context),
        ),
      )
    );
  }

  void _launchURL(BuildContext context) async {
    try {
      await launchUrl(
        Uri.parse(_preferenceUrl),
        prefersDeepLink: true,
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Theme.of(context).primaryColor,
          ),
          shareState: CustomTabsShareState.on,
          closeButton: CustomTabsCloseButton(
            position: CustomTabsCloseButtonPosition.end,
            // and newly added the button icon.
            // icon: CustomTabsCloseButtonIcons.back,
          ),
          urlBarHidingEnabled: true,
          showTitle: true,
          instantAppsEnabled: true,
          animations: const CustomTabsAnimations(
            startEnter: 'slide_up',
            startExit: 'android:anim/fade_out',
            endEnter: 'android:anim/fade_in',
            endExit: 'slide_down',
          ),
          browser: CustomTabsBrowserConfiguration(
            fallbackCustomTabs: [
              // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
              'org.mozilla.firefox',
              // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
              'com.microsoft.emmx',    
            ],
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,        
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}