import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:test/test.dart';

void incrementUnreadMessageCountTest() {
  ChatRoom chatRoom = ChatRoom(
      id: '0',
      name: 'test',
      type: 'meal',
      open: Timestamp.now(),
      users: [1, 2, 3, 4],
      unread: [0, 0, 0, 0],
      lastMsg: Message(
          sender: User(id: 1, intra: 'test1', nickname: 'test'),
          message: 'hi',
          date: Timestamp.now()));

  Message message = Message(
      sender: User(id: 2, intra: 'test2', nickname: 'test2'),
      message: 'test',
      date: Timestamp.now());

  //Send Message...
  chatRoom.addUnreadMessage(message);

  for (int i = 0; i < chatRoom.unread.length; ++i) {
    int id = chatRoom.users[i];

    if (message.isNotSender(id)) {
      expect(chatRoom.unread[i], 1);
    }
  }
}

void readMessagesThenClearUnreadMessageCountTest() {
  ChatRoom chatRoom = ChatRoom(
      id: '0',
      name: 'test',
      type: 'meal',
      open: Timestamp.now(),
      users: [1, 2, 3, 4],
      unread: [2, 3, 4, 5],
      lastMsg: Message(
          sender: User(id: 1, intra: 'test1', nickname: 'test'),
          message: 'hi',
          date: Timestamp.now()));

  chatRoom.readAll(3);

  expect(chatRoom.unread[chatRoom.users.indexOf(3)], 0);
}

void main() {
  group('ChatRoom', () {
    test('send message should increment unread message',
        () => incrementUnreadMessageCountTest());
    test('read message should clear unread message',
        () => readMessagesThenClearUnreadMessageCountTest());
  });
}
