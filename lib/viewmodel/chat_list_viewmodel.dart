import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/service/chat_service.dart';

class ChatListViewModel extends ChangeNotifier {
  ChatListViewModel() {
    _init();
  }

  final ChatService _chatService = ChatService();

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
}
