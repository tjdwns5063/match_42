import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

class ChatListViewModel extends ChangeNotifier {
  ChatListViewModel(User me) : _user = me {
    _init(me);
  }

  final ChatService _chatService = ChatService.instance;

  List<ChatRoom> get rooms => UnmodifiableListView(filterChatRoom());
  List<ChatRoom> _rooms = [];

  User _user;
  late StreamSubscription _subscription;
  int _isOn = 1;
  int get isOn => _isOn;
  int get totalUnread => _rooms.fold(
      0,
      (previousValue, element) =>
          previousValue + element.unread[element.users.indexOf(_user.id)]);

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
      List<ChatRoom> newList = [];
      for (final doc in event.docs) {
        newList.add(doc.data());
      }
      _rooms = newList;
      print('totalUnread: $totalUnread');
      notifyListeners();
      // _updateRooms(me);
    });
  }

  List<ChatRoom> filterChatRoom() {
    if (isOn == 1) {
      return _rooms
          .where((element) =>
              DateTime.now().compareTo(
                  element.open.toDate().add(const Duration(hours: 42))) <
              0)
          .toList();
    }
    return _rooms
        .where((element) =>
            DateTime.now().compareTo(
                element.open.toDate().add(const Duration(hours: 42))) >=
            0)
        .toList();
  }
}
