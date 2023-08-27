import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';

class ChatService {
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
    await roomRef.doc(chatRoom.id).set(chatRoom);
  }

  Future<List<ChatRoom>> getAllChatRoom() async {
    final List<ChatRoom> result = [];
    final QuerySnapshot<ChatRoom> snapshot = await roomRef.get();

    for (QueryDocumentSnapshot<ChatRoom> doc in snapshot.docs) {
      result.add(doc.data());
    }

    return result;
  }

  Future<ChatRoom?> getChatRoom(String id) async {
    final DocumentSnapshot<ChatRoom> snapshot = await roomRef.doc(id).get();

    return snapshot.data();
  }

  Future<void> addMessage(String roomId, Message msg) async {
    ChatRoom? room = await getChatRoom(roomId);

    if (room == null) return;

    _addUnreadMessageCount(room, msg);

    roomRef.doc(roomId).set(room);
    await createMessageRef(roomId).add(msg);
  }

  void _addUnreadMessageCount(ChatRoom room, Message msg) {
    for (int i = 0; i < room.unread.length; ++i) {
      String userIntra = room.users[i].intra;
      String senderIntra = msg.sender.intra;

      if (_isNotSender(userIntra, senderIntra)) {
        room.unread[i] += 1;
      }
    }
  }

  bool _isNotSender(String userIntra, String senderIntra) {
    return userIntra != senderIntra;
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
}
