import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String name;
  final List<String> participants;
  final String lastMessage;
  final Timestamp lastMessageTime; 

  ChatRoom({required this.id, required this.name, required this.participants, required this.lastMessage, required this.lastMessageTime});

  factory ChatRoom.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatRoom(
      id: doc.id,
      name: doc['name'],
      participants: List<String>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      lastMessageTime: doc['lastMessageTime'],
    );
  }
}
