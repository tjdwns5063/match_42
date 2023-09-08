import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/message.dart';

class ChatRoom {
  ChatRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.open,
    required this.users,
    required this.unread,
    required this.lastMsg,
    List<bool>? isOpen,
  }) : isOpen = isOpen ?? [];

  final String id;
  final String name;
  final String type;
  final Timestamp open;
  final List<int> users;
  final List<int> unread;
  final List<bool> isOpen;
  Message lastMsg;

  factory ChatRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    print(data);

    return ChatRoom.fromJson(snapshot.id, data!);
  }

  factory ChatRoom.fromJson(String id, Map<String, dynamic> json) {
    return ChatRoom(
      id: id,
      name: json['name'],
      type: json['type'],
      open: json['open'],
      users: List.from(json['users']),
      unread: List.from(json['unread']),
      isOpen: json['isOpen'] == null
          ? List.filled(List.from(json['users']).length, false)
          : List.from(json['isOpen']),
      lastMsg: Message.fromJson(json['lastMsg']),
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

  void addUnreadMessage(Message msg) {
    for (int i = 0; i < unread.length; ++i) {
      int userId = users[i];

      if (msg.isNotSender(userId)) {
        unread[i] += 1;
      }
    }
  }

  void updateIsOpen(int userId) {
    isOpen[users.indexOf(userId)] = true;
  }

  bool isEveryOpened() {
    return isOpen.every((element) => element == true);
  }

  void readAll(int userId) {
    unread[users.indexWhere((element) {
      return element == userId;
    })] = 0;
  }

  @override
  String toString() {
    return 'id: $id name: $name type: $type open: ${open.toDate()} users: $users';
  }
}
