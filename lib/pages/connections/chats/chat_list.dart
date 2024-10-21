import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/models/chatroom.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatsStream;
  List<ChatRoom> chats = [];
  final FilesService _filesService = FilesService();

  @override
  void initState() {
    super.initState();
    _fetchUserChats();
  }

  Future<void> _fetchUserChats() async {
    final chatService = ChatService();
    try {
      _chatsStream = chatService.fetchUserChatRooms();
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
    setState(() {});
  }

  Future<String?> _fetchConnectionProfilePic(
      List<String> chatParticipants, String currentUserID) async {
    String personID = chatParticipants.firstWhere((id) => id != currentUserID);

    String? imageUrl = await _filesService.getProfileImageUrl(personID);

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              decoration: BaseDecoration.boxCurveLR(context),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(22, 22, 0, 0),
                        child: Text(
                          'Chats',
                          style: ThemeTextStyle.titleMediumOnPrimaryContainer(
                              context),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _chatsStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Error fetching chats: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.hasData) {
                              final chats = snapshot.data!.docs
                                  .map((doc) => ChatRoom.fromFirestore(doc))
                                  .toList();
                              chats.sort((a, b) => b.lastMessageTime
                                  .compareTo(a.lastMessageTime));
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  final chat = chats[index];
                                  return ListTile(
                                    leading: FutureBuilder<String?>(
                                      future: _fetchConnectionProfilePic(
                                          chat.participants,
                                          authProvider.user!.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundColor: theme
                                                .colorScheme.secondaryFixedDim,
                                            child: Icon(Icons.groups),
                                          );
                                        } else if (snapshot.hasError ||
                                            !snapshot.hasData) {
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundColor: theme
                                                .colorScheme.secondaryFixedDim,
                                            child: Icon(Icons
                                                .error),
                                          );
                                        } else {
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    snapshot.data!),
                                          );
                                        }
                                      },
                                    ),
                                    title: Text(chat.name),
                                    subtitle: Text(chat.lastMessage),
                                    trailing: Text(
                                      ' ${getTimeFromTimestamp(chat.lastMessageTime)}',
                                      style: TextStyle(
                                          color: theme.colorScheme.surfaceTint),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(chatRoomId: chat.id),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text('No hay chats.'));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
