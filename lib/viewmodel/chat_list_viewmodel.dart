import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

class ChatListViewModel extends ChangeNotifier {
  ChatListViewModel() {
    _init();
  }

  final ChatService _chatService = ChatService.instance;

  List<ChatRoom> get rooms => UnmodifiableListView(_rooms);
  List<ChatRoom> _rooms = [];

  late StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    _rooms = await _chatService.getAllChatRoom();
    notifyListeners();
    listen();
  }

  void listen() {
    final Stream<QuerySnapshot<ChatRoom>> stream =
        _chatService.roomRef.snapshots();

    _subscription = stream.listen((event) {
      List<ChatRoom> newRooms = [
        for (QueryDocumentSnapshot<ChatRoom> doc in event.docs) doc.data()
      ];
      _rooms = newRooms;
      notifyListeners();
    });
  }

  void testCreateChatRoom() {
    _chatService.addChatRoom(ChatRoom(
        id: _rooms.length.toString(),
        name: 'test${_rooms.length.toString()}',
        type: 'eat',
        open: Timestamp.now(),
        users: [
          User(
              id: 0,
              interests: <String?>[],
              nickname: 'aaaa',
              intra: 'seongjki',
              profile: 'eat'),
          User(
              id: 1,
              interests: <String?>[],
              nickname: 'bbbb',
              intra: 'jiheekan',
              profile: 'eat'),
        ],
        unread: [0, 0],
        lastMsg: Message(
          sender: User(
              id: 0,
              interests: <String?>[],
              nickname: 'system',
              intra: 'system',
              profile: 'system'),
          message: '채팅방이 생성되었습니다',
          date: Timestamp.now(),
        )));
  }
}
