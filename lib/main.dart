import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/signup.dart';
import 'package:mobile/pages/auth/splash_screen.dart';
import 'package:mobile/pages/connections/my_connections.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/payment/failure.dart';
import 'package:mobile/pages/payment/mercadopago.dart';
import 'package:mobile/pages/payment/success.dart';
import 'package:mobile/pages/profile/edit_profile/settings.dart';
import 'package:mobile/pages/profile/my_profile.dart';
import 'package:mobile/pages/wallet/wallet.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:provider/provider.dart';

const Color seedColor = Color.fromARGB(1, 56, 182, 255);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthSessionProvider>(
          create: (context) => AuthSessionProvider(context.read<AuthService>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buddy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
          fontFamily: 'Comfortaa'
        ),
        home: SplashScreen(),
        routes: {
          Routes.login: (context) => LoginPage(),
          Routes.signup: (context) => SignupPage(),
          Routes.splashScreen: (context) => SplashScreen(),
          Routes.home: (context) => HomePage(),
          Routes.myConnections: (context) => MyConnectionsPage(),
          Routes.myProfile: (context) => MyProfilePage(),
          Routes.payment: (context) => MercadoPagoScreen(),
          Routes.paymentSuccess: (context) => PaymentSuccessPage(),
          Routes.paymentFailure: (context) => PaymentFailurePage(),
          Routes.settings: (context) => SettingsPage(),
          Routes.wallet: (context) => WalletPage(),
        },
    );
  }
}
