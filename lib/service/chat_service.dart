import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';

import '../error/http_exception.dart';

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

  Future<void> addChatRoom(ChatRoom chatRoom) async {
    await roomRef.add(chatRoom);
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

  Future<void> addSystemMessage(String roomId, Message msg) async {
    await createMessageRef(roomId).add(msg);
  }

  Future<void> addMessage(String roomId, Message msg) async {
    ChatRoom room = await getChatRoom(roomId) as ChatRoom;

    // User updatedUser = msg.sender
    //   ..decideNickname(room)
    //   ..decideProfile(room);

    // msg = Message(sender: msg.sender, message: msg.message, date: msg.date);

    _addUnreadMessageCount(room, msg);
    room.lastMsg = msg;

    await createMessageRef(roomId).add(msg);
    await roomRef.doc(roomId).set(room);
  }

  void _addUnreadMessageCount(ChatRoom room, Message msg) {
    for (int i = 0; i < room.unread.length; ++i) {
      int userId = room.users[i];
      int senderId = msg.sender.id;

      if (_isNotSender(userId, senderId)) {
        room.unread[i] += 1;
      }
    }
  }

  bool _isNotSender(int userId, int senderId) {
    return userId != senderId;
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

  Future<void> readAllMessage(String roomId, User user) async {
    ChatRoom chatRoom = await getChatRoom(roomId) as ChatRoom;

    chatRoom.unread[chatRoom.users.indexWhere((element) {
      return element == user.id;
    })] = 0;

    roomRef.doc(roomId).update({
      'unread': chatRoom.unread,
    });
  }

  Future<ChatRoom> setIsOpen(String roomId, bool isOpen, int id) async {
    ChatRoom chatRoom = await getChatRoom(roomId) as ChatRoom;

    chatRoom.isOpen![chatRoom.users.indexOf(id)] = true;

    roomRef.doc(roomId).update({
      'isOpen': chatRoom.isOpen,
    });

    return chatRoom;
  }
}
