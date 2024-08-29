import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_connection_card.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';


class Chat {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Chat({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  List<Chat> chats = [
    Chat(id: '1', title: 'Lucas, Marta y yo', lastMessage: 'hello!', lastMessageTime: DateTime.now(), unreadCount: 1),
    Chat(id: '2', title: 'Ana y yo', lastMessage: 'hello', lastMessageTime: DateTime.now(), unreadCount: 2),
    Chat(id: '3', title: 'Lucas y yo', lastMessage: 'hi', lastMessageTime: DateTime.now(), unreadCount: 4),
    Chat(id: '4', title: 'Marta y yo', lastMessage: 'hello', lastMessageTime: DateTime.now(), unreadCount: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primaryContainer,
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 18, 0, 18),
                      child: Text(
                        'Conexiones',
                        style: ThemeTextStyle.titleMediumOnPrimaryContainer(context),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 10, 0, 20),
                  height: 120,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  FutureBuilder<List<Widget>>(
                                    future: fetchConnectionsAsFuture(userData),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        if (snapshot.hasError) {
                                          return Text('Error fetching meetings');
                                        } else {
                                          return Column(
                                            children: snapshot.data!,
                                          );
                                        }
                                      } else {
                                        return CircularProgressIndicator(
                                          color: theme.colorScheme.onPrimaryContainer,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BaseDecoration.boxCurveLR(context),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: chats.length, 
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage('assets/images/avatarBuddy.jpeg'),
                                  ),
                                  title: Text(chats[index].title),
                                  subtitle: Text(chats[index].lastMessage),
                                  trailing: Text(
                                    chats[index].unreadCount > 0 ? '${chats[index].unreadCount} sin leer' : '',
                                    style: TextStyle(color: theme.colorScheme.surfaceTint),
                                  ),
                                  onTap: () {
                                    print('tap chat ${chats[index].id}');
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) =>  ChatScreen()),
                                    // );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}