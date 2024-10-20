import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_list.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_connection_card.dart';
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
                      margin: EdgeInsets.fromLTRB(
                          22, MediaQuery.of(context).padding.top + 18, 0, 18),
                      child: Text(
                        'Conexiones',
                        style: ThemeTextStyle.titleMediumOnPrimaryContainer(
                            context),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 10, 0, 20),
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context)
                          .size
                          .width,
                      child: FutureBuilder<List<Widget>>(
                        future: fetchConnectionsAsFuture(userData),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('Error fetching meetings');
                            } else if (snapshot.data!.isEmpty) {
                              return Text('No hay conexiones');
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: snapshot.data!,
                              );
                            }
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              children: [
                                SizedBox(width: 16,),
                                CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ChatsList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
