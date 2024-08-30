import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/services/chat_service.dart';
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

Future<Widget> buildConnectionCards(Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID, personName) = await userHelper.fetchPersonIDAndName(connection, isBuddy);
  return buildConnectionCard(personID, personName,'image');
}

BaseConnectionCard buildConnectionCard(String personID, String personName, String image) {
  return BaseConnectionCard(
    personID: personID,
    personName: personName,
    image: 'assets/images/avatarBuddy.jpeg',
  );
}

class BaseConnectionCard extends StatelessWidget {
  final String personID;
  final String personName;
  final String image;

  const BaseConnectionCard({
    super.key,
    required this.personID,
    required this.personName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;
    return GestureDetector(
      onTap: () async {
        final chatService = ChatService();
        final chatRoomId = await chatService.createChatRoom(
          personName,
          [personID], userData
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ChatScreen(chatRoomId: chatRoomId)),
        );
      },
      child: Column(
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
              personName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}