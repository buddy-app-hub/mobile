import 'package:flutter/material.dart';

class MyConnectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Mis conexiones"),
        SizedBox(
          height: 20,
        ),
        Text("Por aca va el chat...")
      ],
    )));
  }
}
