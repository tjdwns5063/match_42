import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

class ChatListViewModel extends ChangeNotifier {
  ChatListViewModel(User me) {
    _init(me);
  }

  final ChatService _chatService = ChatService.instance;

  List<ChatRoom> get rooms => UnmodifiableListView(filterChatRoom());
  List<ChatRoom> _rooms = [];

  late StreamSubscription _subscription;
  int _isOn = 1;
  int get isOn => _isOn;

  set isOn(int value) {
    _isOn = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _init(User me) async {
    listen(me);
  }

  Future<void> _updateRooms(User me) async {
    _rooms = await _chatService.getAllChatRoom(me);
    notifyListeners();
  }

  void listen(User me) {
    final Stream<QuerySnapshot<ChatRoom>> stream =
        _chatService.roomRef.snapshots();

    _subscription = stream.listen((event) async {
      _updateRooms(me);
    });
  }

  void testCreateChatRoom(User user1, User user2) {
    _chatService.addChatRoom(ChatRoom(
        id: _rooms.length.toString(),
        name: 'test${_rooms.length.toString()}',
        type: 'eat',
        open: Timestamp.now(),
        users: [
          user1.id,
          user2.id,
        ],
        unread: [0, 0],
        lastMsg: Message(
          sender: User(
              id: 0,
              interests: <String>[],
              nickname: 'system',
              intra: 'system',
              profile: 'system'),
          message: '채팅방이 생성되었습니다',
          date: Timestamp.now(),
        )));
  }

  List<ChatRoom> filterChatRoom() {
    if (isOn == 1) {
      return _rooms;
    }
    return _rooms
        .where((element) =>
            DateTime.now().compareTo(
                element.open.toDate().add(const Duration(hours: 42))) >
            0)
        .toList();
  }
}
