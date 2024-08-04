import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
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
                      if (authProvider.userData != null)
                      ...buildUserDetails(authProvider.userData!),
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

List<Widget> buildUserDetails(UserData userData) {
  List<Widget> details = [];
  
  if (userData.buddy != null) {
    details.add(Text("User Type: Buddy"));
  } else if (userData.elder != null) {
    details.add(Text("User Type: Elder"));
  }

  userData.toJson().forEach((key, value) {
    if (value != null) {
      details.add(Text("$key: $value"));
    }
  });

  return details;
}
