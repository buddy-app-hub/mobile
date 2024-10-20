import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/chatroom.dart';
import 'package:mobile/models/message.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_message.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:provider/provider.dart';

final UserHelper userHelper = UserHelper();

Future<String> fetchSenderData(Message message, UserData userData) async {
  String personName =
      await userHelper.fetchSenderName(message.senderId, userData);
  return personName;
}

bool isSenderUser(Message message, UserData userData) {
  return userHelper.isUserSender(message.senderId, userData);
}

Map<DateTime, List<Message>> groupMessagesByDay(List<Message> messages) {
  final groupedMessages = <DateTime, List<Message>>{};
  for (final message in messages) {
    final messageCompleteDate = message.timestamp.toDate();
    final messageDate = DateTime(messageCompleteDate.year,
        messageCompleteDate.month, messageCompleteDate.day);
    final groupedByDate = groupedMessages[messageDate];
    if (groupedByDate == null) {
      groupedMessages[messageDate] = [message];
    } else {
      groupedByDate.add(message);
    }
  }
  return groupedMessages;
}

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final chatService = ChatService();
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;
  ChatRoom? chatRoom;
  final ScrollController _scrollController = ScrollController();
  FilesService _filesService = FilesService();

  @override
  void initState() {
    super.initState();
    _fetchChatRoomData();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    _messagesStream = chatService.fetchMessages(widget.chatRoomId);
    _messagesStream?.listen((snapshot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  Future<void> _fetchChatRoomData() async {
    final chatRoomDoc = await chatService.fetchUserChatRoom(widget.chatRoomId);
    if (chatRoomDoc.exists) {
      final chatRoomData = ChatRoom.fromJson(chatRoomDoc.data()!);
      setState(() {
        chatRoom = chatRoomData;
      });
    } 
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondaryFixedDim,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            chatRoom == null
                ? Text("")
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: FutureBuilder<String?>(
                      future: _filesService.fetchConnectionProfilePic(
                          chatRoom!.participants, authProvider.user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                theme.colorScheme.secondaryFixedDim,
                            child: Icon(Icons.groups),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                theme.colorScheme.secondaryFixedDim,
                            child: Icon(Icons.error),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                CachedNetworkImageProvider(snapshot.data!),
                          );
                        }
                      },
                    ),
                  ),
            Flexible(
              child: Text(
                chatRoom == null ? '' : chatRoom!.name,
                style: ThemeTextStyle.titleMediumOnPrimaryContainer(context),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Error al cargar mensajes: ${snapshot.error}');
                  return Center(
                      child:
                          Text('Error fetching messages: ${snapshot.error}'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Text("olis"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                } else {
                  final messages = snapshot.data!.docs
                      .map((doc) => Message.fromFirestore(doc))
                      .toList();
                  print("Mensajes cargados: ${messages.length}");
                  messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  final groupedMessages = groupMessagesByDay(messages);
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.zero,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      final date = groupedMessages.keys.elementAt(index);
                      final dayMessages = groupedMessages[date]!;
                      dayMessages
                          .sort((a, b) => a.timestamp.compareTo(b.timestamp));
                      String? lastSenderId;

                      return Column(
                        children: [
                          Chip(
                            label: Text(formatDateChat(date)),
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide.none,
                            ),
                          ),
                          ...dayMessages.map((message) {
                            final isNewSender =
                                lastSenderId != message.senderId;
                            lastSenderId = message.senderId;
                            return FutureBuilder<String>(
                              future: fetchSenderData(message, userData),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error fetching sender name');
                                } else {
                                  final senderName = snapshot.data!;
                                  final isUser =
                                      isSenderUser(message, userData);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isNewSender && !isUser)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 10, 10, 10),
                                          child: Text(
                                            senderName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ChatMessage(
                                        text: message.text,
                                        isUser: isSenderUser(message, userData),
                                        senderName: senderName,
                                        timestamp: message.timestamp,
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          })
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                    _messageController.clear();
                  },
                  icon: Icon(Icons.send_rounded,
                      color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await chatService.sendMessage(widget.chatRoomId, message);
    }
  }
}
