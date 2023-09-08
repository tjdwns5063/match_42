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
      {required this.roomId, required this.user, required this.token}) {
    init();
  }

  final ChatService _chatService = ChatService.instance;
  final UserService _userService = UserService.instance;
  final String roomId;
  final User user;
  final String token;

  ChatRoom get chatRoom => _chatRoom;
  ChatRoom _chatRoom = ChatRoom(
      id: '0',
      name: 'test',
      type: 'eat',
      open: Timestamp.now(),
      users: [0, 0],
      unread: [0, 0],
      lastMsg: Message(
          sender: User(id: 0, nickname: '', intra: ''),
          message: '',
          date: Timestamp.now()));

  List<Message> _messages = [];
  List<Message> get messages => UnmodifiableListView(
      _messages..sort((Message m1, Message m2) => m1.date.compareTo(m2.date)));

  late StreamSubscription _chatSubscription;
  late StreamSubscription _readSubscription;

  RemainTimer? timer;
  int get remainTime => timer?.remainTime ?? 42;

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
    final chatStream = _chatService.createMessageRef(roomId).snapshots();

    _chatSubscription = chatStream.listen((event) async {
      _messages = await _chatService.getAllMessage(roomId);
      notifyListeners();
    });

    final readStream = _chatService.roomRef.doc(roomId).snapshots();

    _readSubscription = readStream.listen((event) async {
      _chatRoom = event.data()!;
      timer = RemainTimer(openTime: _chatRoom.open, notify: notifyListeners);
      _readAll();
      notifyListeners();
    });
  }

  void send(User sender, TextEditingController text) {
    if (text.text.isEmpty) return;

    Message message = Message(
        sender: sender
          ..decideProfile(chatRoom)
          ..decideNickname(chatRoom),
        message: text.text,
        date: Timestamp.now());

    _addMessage(message);

    for (int userId in chatRoom.users) {
      if (user.id == userId) continue;
      _userService.sendNotification(
          userId,
          '${(chatRoom.type.toLowerCase() == 'chat') ? sender.nickname : sender.intra}: ${text.text}',
          token);
    }

    text.clear();
  }

  void sendSystem(String msg) {
    if (msg.isEmpty) return;

    User system = User(id: 0, nickname: 'system', intra: 'system');

    _chatService.addSystemMessage(
        roomId, Message(sender: system, message: msg, date: Timestamp.now()));
  }

  String parseHMS() {
    if (timer == null) return 'Loading...';

    int remain = remainTime;

    int h = remain ~/ 3600;

    remain -= h * 3600;

    int m = remain ~/ 60;

    remain -= m * 60;

    int s = remain;

    return '$h : $m : $s 남음';
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

    await _chatService.createMessageRef(roomId).add(msg);
    await _chatService.roomRef.doc(roomId).set(_chatRoom);
  }

  Future<void> _readAll() async {
    _chatRoom.readAll(user.id);

    await _chatService.updateUnread(_chatRoom);
  }
}
