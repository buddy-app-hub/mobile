import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String weatherIcon = "https://cdn.weatherapi.com/weather/64x64/day/113.png";
  String weatherCity = '?º';
  Future<void> getPost() async {

    var jsonb = await ApiService.get<dynamic>(
        endpoint: "http://api.weatherapi.com/v1/current.json",
        params: {
          "key": "d35441289f874f678a135931240506",
          "q": "Bariloche",
          "aqi": "yes"
    });

    var icon = jsonb["current"]["condition"]["icon"];
    var locName = jsonb["location"]["name"];
    var temp = jsonb["current"]["temp_c"].toString();

    /*try {
      var api = await ApiService.get<String>(endpoint: "http://localhost:8080/ping", params: {});
      print(api);
    } catch (e) {
      print("Error");
    }*/

    setState(() {
      weatherIcon = "https:${icon}";
    });
    setState(() {
      weatherCity = "${locName} ${temp}º";
    });

    /*if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      setState(() {
        weatherIcon = "https:${data["current"]["condition"]["icon"]}";
      });
      setState(() {
        weatherCity = data["location"]["name"] +
            " " +
            data["current"]["temp_c"].toString() +
            "º";
      });
    } else {
      throw Exception("No funciono la conexion");
    }*/
  }

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
                  Text(authProvider.user?.email ?? "No logueado"),
                  ElevatedButton(
                      onPressed: getPost, child: Text('Get current weather')),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Image.network(weatherIcon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(weatherCity),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authProvider.signOut();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
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
