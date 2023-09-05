import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';

class ChatRoom {
  ChatRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.open,
    required this.users,
    required this.unread,
    required this.lastMsg,
    this.isOpen,
  });

  final String id;
  final String name;
  final String type;
  final Timestamp open;
  final List<int> users;
  final List<int> unread;
  List<bool>? isOpen;
  Message lastMsg;

  factory ChatRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatRoom(
      id: snapshot.id,
      name: data!['name'],
      type: data['type'],
      open: data['open'],
      users: List.from(data['users']),
      unread: List.from(data['unread']),
      isOpen: data['isOpen'] == null
          ? List.filled(List.from(data['users']).length, false)
          : List.from(data['isOpen']),
      lastMsg: Message.fromJson(data['lastMsg']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'open': open,
      'users': users,
      'unread': unread,
      'isOpen': isOpen,
      'lastMsg': lastMsg.toFirestore(),
    };
  }

  @override
  String toString() {
    return 'id: $id name: $name type: $type open: ${open.toDate()} users: $users';
  }
}
