import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/choose_user.dart';
import 'package:mobile/pages/navigation.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthSessionProvider>(builder: (context, authProvider, _) {
      if (authProvider.isAuthenticated) {
        return Navigation();
      }
      if (authProvider.userData != null &&
          authProvider.userData!.userWithPendingSignUp) {
        return ChooseUserPage();
      }

      return LoginPage();
    });
  }
}
