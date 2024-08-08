import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Mi perfil"),
        SizedBox(height: 20,),
        ElevatedButton(
          onPressed: () async {
            await authProvider.signOut();
            Navigator.pushReplacementNamed(context, Routes.login);
          },
          child: Text('Logout'),
        ),
      ],
    )));
  }
}
