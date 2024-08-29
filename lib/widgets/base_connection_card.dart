import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/user_data.dart';

UserHelper userHelper = UserHelper();

Future<List<Widget>> fetchConnectionsAsFuture(UserData userData) async {
  final stream = fetchConnections(userData);
  return stream.toList();
}


Stream<Widget> fetchConnections(UserData userData) async* {
  List<Connection> connections = await userHelper.fetchConnections(userData);

  for (var connection in connections) {
    yield await buildConnectionCards(connection, userData);
  }
}

Future<Widget> buildConnectionCards(Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personName = await userHelper.fetchPersonName(connection, isBuddy);
  return buildConnectionCard('image', personName);
}

BaseConnectionCard buildConnectionCard(String image, String personName) {
  return BaseConnectionCard(
    image: 'assets/images/avatarBuddy.jpeg',
    person: personName,
  );
}

class BaseConnectionCard extends StatelessWidget {
  final String image;
  final String person;

  const BaseConnectionCard({
    super.key,
    required this.image,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 80,
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            person,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}