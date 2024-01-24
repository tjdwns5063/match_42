import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static final ChatService instance = ChatService._create();

  ChatService._create();

  static const String roomCollectionPath = 'rooms';
  static const String messageCollectionPath = 'messages';

  final CollectionReference<ChatRoom> roomRef = FirebaseFirestore.instance
      .collection(roomCollectionPath)
      .withConverter(
          fromFirestore: ChatRoom.fromFirestore,
          toFirestore: (ChatRoom room, options) => room.toFirestore());

  CollectionReference<Message> createMessageRef(String roomId) {
    return FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(roomId)
        .collection(messageCollectionPath)
        .withConverter(
            fromFirestore: Message.fromFirestore,
            toFirestore: (Message msg, options) => msg.toFirestore());
  }

  Future<DocumentReference<ChatRoom>> addChatRoom(ChatRoom chatRoom) async {
    return await roomRef.add(chatRoom);
  }

  Future<List<ChatRoom>> getAllChatRoom(User me) async {
    final QuerySnapshot<ChatRoom> snapshot =
        await roomRef.where('users', arrayContains: me.id).get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<ChatRoom?> getChatRoom(String id) async {
    final DocumentSnapshot<ChatRoom> snapshot = await roomRef.doc(id).get();

    return snapshot.data();
  }

  Future<void> addMessage(String roomId, Message msg) async {
    await createMessageRef(roomId).add(msg);
  }

  Future<List<Message>> getAllMessage(String roomId) async {
    final List<Message> result = [];
    final QuerySnapshot<Message> snapshot =
        await createMessageRef(roomId).get();

    for (QueryDocumentSnapshot<Message> doc in snapshot.docs) {
      result.add(doc.data());
    }
    return result;
  }

  Future<void> updateChatRoom(ChatRoom chatRoom) async {
    await roomRef.doc(chatRoom.id).set(chatRoom);
  }

  Future<void> updateUnread(ChatRoom chatRoom) async {
    roomRef.doc(chatRoom.id).update({
      'unread': chatRoom.unread,
    });
  }

  Future<void> updateIsOpen(ChatRoom chatRoom) async {
    roomRef.doc(chatRoom.id).update({
      'isOpen': chatRoom.isOpen,
    });
  }

  Future<void> sendReport(
      int userId, List<String> reasons, String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/user/report');

    http.Response response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'reportedId': userId,
          'reasons': reasons,
        }));

    print('report: ${response.body}');
  }
}
