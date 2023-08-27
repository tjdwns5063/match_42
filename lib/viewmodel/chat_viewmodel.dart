import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({required this.roomId}) {
    init();
  }

  final ChatService _chatService = ChatService();
  final String roomId;

  List<Message> _messages = [];
  List<Message> get messages => UnmodifiableListView(
      _messages..sort((Message m1, Message m2) => m1.date.compareTo(m2.date)));

  void init() {
    _chatService.getAllMessage(roomId).then((List<Message> messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  void listen() {
    _chatService.createMessageRef(roomId).snapshots().listen((event) {
      _chatService.getAllMessage(roomId).then((value) {
        _messages = value;
        notifyListeners();
      });
    });
  }

  void send(User sender, TextEditingController msg) {
    if (msg.text.isEmpty) return;

    _chatService.addMessage(roomId,
        Message(sender: sender, message: msg.text, date: Timestamp.now()));
    msg.clear();
  }
}
