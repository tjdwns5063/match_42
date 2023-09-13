import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/remain_timer.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/user_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel(
      {required ChatRoom chatRoom,
      required this.user,
      required this.token,
      required ChatService chatService,
      required UserService userService})
      : _chatService = chatService,
        _userService = userService,
        _chatRoom = chatRoom {
    init();
  }

  final ChatService _chatService;
  final UserService _userService;
  final User user;
  final String token;

  ChatRoom get chatRoom => _chatRoom;
  ChatRoom _chatRoom;

  List<Message> _messages = [];
  List<Message> get messages => UnmodifiableListView(
      _messages..sort((Message m1, Message m2) => m1.date.compareTo(m2.date)));

  late StreamSubscription _chatSubscription;
  late StreamSubscription _readSubscription;

  RemainTimer? timer;
  String get remainTime => timer?.parseRemainTime() ?? '42:0:0 남음';

  @override
  void dispose() {
    _chatSubscription.cancel();
    _readSubscription.cancel();
    timer?.timer.cancel();
    super.dispose();
  }

  Future<void> init() async {
    listen();
  }

  void listen() {
    final chatStream = _chatService.createMessageRef(chatRoom.id).snapshots();

    _chatSubscription = chatStream.listen((event) async {
      _messages = await _chatService.getAllMessage(chatRoom.id);
      notifyListeners();
    });

    final readStream = _chatService.roomRef.doc(chatRoom.id).snapshots();

    _readSubscription = readStream.listen((event) async {
      _chatRoom = event.data() ?? _chatRoom;

      timer = RemainTimer(openTime: _chatRoom.open, notify: notifyListeners);
      await _readAll();
      notifyListeners();
    });
  }

  void _sendNotificationInChatRoom(User sender, String text) {
    for (int userId in chatRoom.users) {
      if (user.id == userId) continue;
      _userService.sendNotification(
          userId,
          '${(chatRoom.type.toLowerCase() == 'chat') ? sender.nickname : sender.intra}: $text',
          token);
    }
  }

  Future<void> send(User sender, TextEditingController text) async {
    if (text.text.isEmpty) return;

    Message message = Message(
        sender: sender
          ..decideProfile(chatRoom)
          ..decideNickname(chatRoom),
        message: text.text,
        date: Timestamp.now());

    await _addMessage(message);
    _sendNotificationInChatRoom(sender, text.text);
    text.clear();
  }

  void sendSystem(String msg) {
    if (msg.isEmpty) return;

    User system = User(id: 0, nickname: 'system', intra: 'system');

    _chatService.addMessage(chatRoom.id,
        Message(sender: system, message: msg, date: Timestamp.now()));
  }

  Future<void> updateOpenResult() async {
    _chatRoom.updateIsOpen(user.id);

    if (_chatRoom.isEveryOpened()) {
      _sendMatchMessage();
    }
    notifyListeners();
  }

  Future<void> _sendMatchMessage() async {
    List<String> intras =
        await _userService.getUserIntraNames(chatRoom.users, token);
    String names = intras.toString();

    for (int userId in chatRoom.users) {
      _userService.sendNotification(
          userId, '${names.substring(1, names.length - 1)} 님이 매치되었습니다', token);
    }
  }

  Future<void> _addMessage(Message msg) async {
    _chatRoom.addUnreadMessage(msg);
    _chatRoom.lastMsg = msg;

    await _chatService.addMessage(chatRoom.id, msg);
    await _chatService.updateChatRoom(chatRoom);
  }

  Future<void> _readAll() async {
    _chatRoom.readAll(user.id);

    await _chatService.updateUnread(_chatRoom);
  }

  bool isRemainTime() {
    return (timer?.remainTime ?? 42 * 3600) > 0;
  }
}
