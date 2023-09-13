import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/user_service.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test/chat_room_test.dart';
import 'FirebaseSetter.dart';
@GenerateNiceMocks([MockSpec<UserService>()])
import 'chat_viewmodel_test.mocks.dart';

Future<void> sendMessageTest() async {
  User me = User(id: 1, nickname: '', intra: 'seongjki', profile: '');
  MockUserService userService = MockUserService();
  ChatService chatService = ChatService.instance;
  ChatRoom chatRoom = ChatRoomCreator.create();
  await chatService.addChatRoom(chatRoom);

  ChatViewModel chatViewModel = ChatViewModel(
      chatRoom: chatRoom,
      user: me,
      token: 'token',
      chatService: chatService,
      userService: userService);

  await chatViewModel.send(me, TextEditingController(text: 'hello'));

  verify(userService.sendNotification(2, 'seongjki: hello', 'token'));
  expect(chatViewModel.messages[0].message, 'hello');

  chatViewModel.dispose();
}

Future<void> whenRemainTimeZeroAllUserDecideOpenIdTest() async {
  User me = User(id: 1, nickname: '', intra: 'seongjki', profile: '');
  MockUserService userService = MockUserService();
  ChatService chatService = ChatService.instance;
  ChatRoom chatRoom = ChatRoomCreator.create();
  chatRoom.updateIsOpen(2);
  await chatService.addChatRoom(chatRoom);

  when(userService.getUserIntraNames([1, 2], 'token'))
      .thenAnswer((_) => Future.value(['seongjki', 'jiheekan']));

  ChatViewModel chatViewModel = ChatViewModel(
      chatRoom: chatRoom,
      user: me,
      token: 'token',
      chatService: chatService,
      userService: userService);

  await chatViewModel.updateOpenResult();

  expect(chatViewModel.chatRoom.isEveryOpened(), true);
  verifyInOrder([
    userService.getUserIntraNames([1, 2], 'token'),
    userService.sendNotification(1, 'seongjki, jiheekan 님이 매치되었습니다', 'token'),
    userService.sendNotification(2, 'seongjki, jiheekan 님이 매치되었습니다', 'token')
  ]);

  chatViewModel.dispose();
}

Future<void> main() async {
  await FirebaseSetter.init();

  setUp(() async {
    FirebaseSetter.deleteFirestore();
  });

  group('chat viewmodel test', () {
    test('메세지 전송 기능 테스트', () => sendMessageTest());
    test('채팅 시간이 끝난 후, 모두 아이디 공개를 결정한 경우를 테스트',
        () => whenRemainTimeZeroAllUserDecideOpenIdTest());
  });
}
