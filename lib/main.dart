import 'package:flutter/material.dart';

import 'pages/auth/login.dart';
import 'pages/auth/signup.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Comfortaa'),
        home: const SignupPage());
  }
}
