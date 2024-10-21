import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatRoom {
  final String id;
  final String name;
  final List<String> participants;
  final String lastMessage;

  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  final Timestamp lastMessageTime;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatRoom(
      id: doc.id,
      name: doc['name'],
      participants: List<String>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      lastMessageTime: doc['lastMessageTime'],
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  static Timestamp _fromTimestamp(dynamic json) => json as Timestamp;
  static dynamic _toTimestamp(Timestamp timestamp) => timestamp;
}
