import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/viewmodel/chat_list_viewmodel.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';

import '../test/chat_room_test.dart';
import 'FirebaseSetter.dart';
import 'chat_viewmodel_test.mocks.dart';

class ChatListViewModelTest {
  late User me;
  late ChatService chatService;
  late ChatListViewModel chatListViewModel;

  Future<void> init() async {
    me = User(id: 1, intra: 'seongjki');
    chatService = ChatService.instance;
    chatListViewModel = ChatListViewModel(me, chatService);
  }

  Future<void> createRoomTest() async {
    ChatRoom chatRoom = ChatRoomCreator.create();
    final ref = await chatService.addChatRoom(chatRoom);

    expect(chatListViewModel.rooms[0].id, ref.id);
  }

  Future<void> unreadCountTest() async {
    User other = User(id: 2, intra: 'jiheekan');
    ChatRoom chatRoom = ChatRoomCreator.create();
    final ref = await chatService.addChatRoom(chatRoom);
    final chatViewModel = ChatViewModel(
        roomId: ref.id,
        user: other,
        token: 'token',
        userService: MockUserService(),
        chatService: chatService);
    await chatViewModel.send(other, TextEditingController(text: 'hi'));

    expect(chatListViewModel.rooms[0].unread[chatRoom.users.indexOf(me.id)], 1);

    chatViewModel.dispose();
  }

  Future<void> totalUnreadCountTest() async {
    User other = User(id: 2, intra: 'jiheekan');
    ChatRoom chatRoom = ChatRoomCreator.create();
    ChatRoom chatRoom2 = ChatRoomCreator.create();

    final ref = await chatService.addChatRoom(chatRoom);
    final ref2 = await chatService.addChatRoom(chatRoom2);

    final chatViewModel = ChatViewModel(
        roomId: ref.id,
        user: other,
        token: 'token',
        userService: MockUserService(),
        chatService: chatService);

    final chatViewModel2 = ChatViewModel(
        roomId: ref2.id,
        user: other,
        token: 'token',
        userService: MockUserService(),
        chatService: chatService);

    await chatViewModel.send(other, TextEditingController(text: 'hi'));
    await chatViewModel2.send(other, TextEditingController(text: 'hi'));
    await chatViewModel2.send(other, TextEditingController(text: 'hi'));

    expect(chatListViewModel.totalUnread, 3);

    chatViewModel.dispose();
    chatViewModel2.dispose();
  }

  Future<void> disabledChatRoomFilterTest() async {
    ChatRoom chatRoomOff = ChatRoom(
        id: '1',
        name: '',
        type: 'meal',
        open: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 43))),
        users: [1, 2],
        unread: [0, 0],
        lastMsg: Message(
            sender: User(id: 0, intra: 'system'),
            message: 'test',
            date: Timestamp.now()));
    ChatRoom chatRoomOn = ChatRoomCreator.create();

    chatListViewModel.isOn = 2; // 2 == 비활성화 된 채팅방

    final refOff = await chatService.addChatRoom(chatRoomOff);
    await chatService.addChatRoom(chatRoomOn);

    expect(chatListViewModel.rooms.length, 1);
    expect(chatListViewModel.rooms[0].id, refOff.id);
  }
}

Future<void> main() async {
  await FirebaseSetter.init();
  ChatListViewModelTest chatListViewModelTest = ChatListViewModelTest();

  setUp(() async {
    await FirebaseSetter.deleteFirestore();
    await chatListViewModelTest.init();
  });

  tearDown(() => chatListViewModelTest.chatListViewModel.dispose());

  group('ChatListViewModel Test', () {
    test('채팅방 생성이 잘 적용 되는지 테스트', () => chatListViewModelTest.createRoomTest());
    test('채팅방의 읽지 않은 메시지 개수가 잘 세어지는지 테스트',
        () => chatListViewModelTest.unreadCountTest());
    test('모든 채팅방의 읽지 않은 메시지가 잘 세어지는지 테스트',
        () => chatListViewModelTest.totalUnreadCountTest());
    test('채팅 목록 비활성화 된 채팅방 필터 테스트',
        () => chatListViewModelTest.disabledChatRoomFilterTest());
  });
}
