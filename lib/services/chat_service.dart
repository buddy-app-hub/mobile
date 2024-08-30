
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/user_data.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory ChatService() {
    return _instance;
  }
  ChatService._internal();

  User? get currentUser => _auth.currentUser;

  //crea o devuelve el primer chat
  Future<String> createChatRoom(String name, List<String> participants, UserData userData) async {
    //TODO si el elder tendria que agregar al lovedOne
    participants.add(currentUser!.uid);
    
    final chatRooms = await _firestore.collection('chatRooms').where('participants', arrayContainsAny: participants).get();

    if (chatRooms.docs.isEmpty) {
      String groupName = '';

      if (userData.buddy == null) {
        if (userData.elder!.onLovedOneMode) {
          groupName = '$name, ${userData.elder!.personalData.firstName} y ${userData.elder!.lovedOne!.firstName} ';
        } else {
          groupName = '${userData.elder!.personalData.firstName} y $name';
        }
      } else {
        groupName = '${currentUser!.displayName} y $name';
      }

      final chatRoomId = _firestore.collection('chatRooms').doc().id;
      print('Creo el chat entre ambos');
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'id': chatRoomId,
        'name': groupName,
        'participants': participants,
        'messages': [],
        'lastMessage': '',
        'lastMessageTime': DateTime.timestamp(),
      });
      return chatRoomId;
    } else {
      print('Existe el chat entre ambos');
      return chatRooms.docs.first.id;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserChatRooms() {
    return _firestore.collection('chatRooms').where('participants', arrayContains: currentUser?.uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserChatRoom(String id) {
    return _firestore.collection('chatRooms').doc(id).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms() {
    return _firestore.collection('chatRooms').where('participants', arrayContains: currentUser?.uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages(String chatRoomId) {
    return _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    final timestamp = DateTime.now();

    await _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').add({
      'senderId': currentUser?.uid,
      'text': message,
      'timestamp': timestamp,
    });

    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });
  }
}