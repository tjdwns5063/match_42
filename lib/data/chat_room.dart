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
  });

  final String id;
  final String name;
  final String type;
  final Timestamp open;
  final List<User> users;
  final List<int> unread;
  Message lastMsg;

  factory ChatRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatRoom(
      id: data!['id'],
      name: data['name'],
      type: data['type'],
      open: data['open'],
      users: [
        for (Map<String, dynamic> json in data['users']) User.fromJson(json)
      ],
      unread: List.from(data['unread']),
      lastMsg: Message.fromJson(data['lastMsg']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'open': open,
      'users': [for (User user in users) user.toFirestore()],
      'unread': unread,
      'lastMsg': lastMsg.toFirestore(),
    };
  }

  @override
  String toString() {
    return 'name: $name type: $type open: ${open.toDate()} users: $users';
  }
}
