import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/home/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(theme),
      body: HomeContentPage(),
    );
  }

  AppBar appBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'Buddy',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
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
