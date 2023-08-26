import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/user.dart';

class Message {
  Message({
    required this.sender,
    required this.message,
    required this.date,
    required this.isRead,
  });

  final User sender;
  final String message;
  final Timestamp date;
  final bool isRead;

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      sender: User.fromJson(data!['sender']),
      message: data['message'],
      date: data['date'],
      isRead: data['isRead'],
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      message: json['message'],
      date: json['date'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender': sender.toFirestore(),
      'message': message,
      'date': date,
      'isRead': isRead,
    };
  }

  @override
  String toString() {
    return 'sender: $sender message: $message date: ${date.toDate()} isRead: $isRead';
  }
}
