import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/profile/view_profile.dart';
import 'package:provider/provider.dart';

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

Future<Widget> buildConnectionCards(
    Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID, personName) =
      await userHelper.fetchPersonIDAndName(connection, isBuddy);
  String? imageUrl = await userHelper.loadProfileImage(personID);
  return buildConnectionCard(connection, personID, personName, imageUrl);
}

BaseConnectionCard buildConnectionCard(
    Connection connectionID, String personID, String personName, String image) {
  return BaseConnectionCard(
    connection: connectionID,
    personID: personID,
    personName: personName,
    image: image,
  );
}

class BaseConnectionCard extends StatelessWidget {
  final Connection connection;
  final String personID;
  final String personName;
  final String image;

  const BaseConnectionCard({
    super.key,
    required this.connection,
    required this.personID,
    required this.personName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    bool isBuddy = authProvider.userData!.buddy != null;
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewProfilePage(
                  connection: connection,
                  personID: personID,
                  isBuddy: isBuddy)),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: image.isEmpty
                    ? const AssetImage('assets/images/default_user.jpg')
                    : CachedNetworkImageProvider(image) as ImageProvider,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 80,
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              personName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
