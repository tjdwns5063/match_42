import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:test/test.dart';

class ChatRoomCreator {
  static ChatRoom createGroup() {
    return ChatRoom(
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
  }

  static ChatRoom create() {
    return ChatRoom(
        id: '0',
        name: 'test',
        type: 'meal',
        open: Timestamp.now(),
        users: [1, 2],
        unread: [0, 0],
        lastMsg: Message(
            sender: User(id: 1, intra: 'test1', nickname: 'test'),
            message: 'hi',
            date: Timestamp.now()));
  }
}

void incrementUnreadMessageCountTest() {
  ChatRoom chatRoom = ChatRoomCreator.createGroup();

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
  ChatRoom chatRoom = ChatRoomCreator.createGroup();

  chatRoom.readAll(3);

  expect(chatRoom.unread[chatRoom.users.indexOf(3)], 0);
}

void updateOpenStateTest() {
  User me = User(id: 1, nickname: 'me', intra: 'seongjki');

  ChatRoom chatRoom = ChatRoomCreator.create();

  chatRoom.updateIsOpen(me.id);

  expect(chatRoom.isOpen[chatRoom.users.indexOf(me.id)], true);
}

void checkAllUserIsOpenTest() {
  ChatRoom chatRoom = ChatRoomCreator.create();

  chatRoom.updateIsOpen(1);
  chatRoom.updateIsOpen(2);

  bool result = chatRoom.isEveryOpened();

  expect(result, true);
}

void main() {
  group('ChatRoom', () {
    test('send message should increment unread message',
        () => incrementUnreadMessageCountTest());
    test('read message should clear unread message',
        () => readMessagesThenClearUnreadMessageCountTest());
    test('update isOpen should be true', () => updateOpenStateTest());
    test('check all user isOpen true', () => checkAllUserIsOpenTest());
  });
}
