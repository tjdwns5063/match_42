import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/user.dart';

class Message {
  Message({
    required this.sender,
    required this.message,
    required this.date,
  });

  final User sender;
  final String message;
  final Timestamp date;

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      sender: User.fromJson(data!['sender']),
      message: data['message'],
      date: data['date'],
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: User.fromJson(json['sender']),
      message: json['message'] ?? '채팅방이 생성되었습니다.',
      date: json['date'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender': sender.toFirestore(),
      'message': message,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'sender: $sender message: $message date: ${date.toDate()}';
  }
}

extension FormatDate on Timestamp {
  String toFormatString() {
    DateTime date = toDate();

    String prefix = date.hour >= 12 ? '오후' : '오전';
    String hour = date.hour > 12 ? '${date.hour - 12}' : '${date.hour}';
    String min = date.minute < 10 ? '0${date.minute}' : date.minute.toString();
    return '$prefix $hour:$min';
  }
}
