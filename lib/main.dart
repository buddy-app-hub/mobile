import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/pages/auth/become_buddy.dart';
import 'package:mobile/pages/auth/choose_user.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/signup.dart';
import 'package:mobile/pages/auth/splash_screen.dart';
import 'package:mobile/pages/auth/want_buddy_loved_one.dart';
import 'package:mobile/pages/auth/want_buddy_myself.dart';
import 'package:mobile/pages/connections/my_connections.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/payment/failure.dart';
import 'package:mobile/pages/payment/pay.dart';
import 'package:mobile/pages/payment/success.dart';
import 'package:mobile/pages/profile/settings.dart';
import 'package:mobile/pages/profile/my_profile.dart';
import 'package:mobile/pages/wallet/wallet.dart';
// import 'package:mobile/pages/profile/view_profile.dart';
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

/*final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'details/:itemId',
            builder: (context, state) =>
                DetailsScreen(id: state.pathParameters['itemId']!),
          )
        ],
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => '/',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    refreshListenable: ref.read(userInfoProvider),
    redirect: (context, state) {
      // Check if the user is logged in
      final isLoggedIn = ref.read(userInfoProvider).isLoggedIn;
      // Check if the current navigation target is the login page
      final isLoggingIn = state.matchedLocation == '/login';

      // Construct a string representing the location from which the user is being redirected
      // If the current location is the root ('/'), set savedLocation to an empty string
      // Otherwise, append the current location to the string '?from='
      final savedLocation =
          state.matchedLocation == '/' ? '' : '?from=${state.matchedLocation}';

      // If the user is not logged in and is not currently navigating to the login page,
      // redirect them to the login page, appending the savedLocation as a query parameter
      // If the user is not logged in but is already navigating to the login page,
      // return null (no additional redirection is necessary)
      if (!isLoggedIn) return isLoggingIn ? null : '/login$savedLocation';

      // If the user is logged in and is currently on the login page,
      // check if there's a 'from' query parameter, which represents the initial page the user was trying to access
      // If this parameter exists, redirect the user to that page
      // Otherwise, redirect them to the root ('/')
      if (isLoggingIn) return state.uri.queryParameters['from'] ?? '/';

      // If the user is logged in and is not on the login page, return null (no redirection is necessary)
      return null;
    },
  );
});*/

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
        // routeInformationParser: Routes.routeInformationParser,
        //routerDelegate: Routes.routerDelegate(context.read<AuthSessionProvider>()),
        home: SplashScreen(),
        routes: {
          Routes.login: (context) => LoginPage(),
          Routes.signup: (context) => SignupPage(),
          Routes.splashScreen: (context) => SplashScreen(),
          Routes.home: (context) => HomePage(),
          Routes.myConnections: (context) => MyConnectionsPage(),
          Routes.myProfile: (context) => MyProfilePage(),
          Routes.payment: (context) => PaymentPage(),
          Routes.paymentSuccess: (context) => PaymentSuccessPage(),
          Routes.paymentFailure: (context) => PaymentFailurePage(),
          Routes.settings: (context) => SettingsPage(),
          // Routes.viewProfile: (context) => ViewProfilePage(),
          Routes.chooseUser: (context) => const ChooseUserPage(),
          Routes.beBuddy: (context) => const BecomeBuddyPage(),
          Routes.wallet: (context) => WalletPage(),
          Routes.wantBuddyForMyself: (context) => const WantBuddyForMyselfPage(),
          Routes.wantBuddyForLovedOne: (context) => const WantBuddyForLovedOnePage(),
        },
    );
  }
}
