import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(theme),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column( // TODO: mostrar la data segun el usuario. Deberiamos tener los mismos models que el back para parsearlos
                    children: [ 
                      Text(authProvider.user?.email ?? "No logueado"),
                      Text(authProvider.userData?['firstName'] ?? "No data"),
                      Text(authProvider.userData?['lastName'] ?? "No data"),
                      Text(authProvider.userData?['age'].toString() ?? "No data"),
                      Text(authProvider.userData?['gender'].toString() ?? "No data"),
                      Text(authProvider.userData?['occupation'].toString() ?? "No data"),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signOut();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'Buddy',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}

