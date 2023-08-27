import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/service/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({required this.roomId}) {
    init();
  }

  final ChatService _chatService = ChatService();
  final String roomId;

  List<Message> _messages = [];
  List<Message> get message => UnmodifiableListView(_messages);

  void init() {
    _chatService.getAllMessage(roomId).then((List<Message> messages) {
      _messages = messages;
      notifyListeners();
    });
  }
}
