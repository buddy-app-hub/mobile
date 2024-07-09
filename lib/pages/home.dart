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

    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Buddy',
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color.fromARGB(255, 172, 138, 230),
      elevation: 0.0,
      centerTitle: true,
    );
  }
}

