import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({required this.roomId, required this.user}) {
    init();
  }

  final ChatService _chatService = ChatService.instance;
  final String roomId;
  final User user;

  List<Message> _messages = [];
  List<Message> get messages => UnmodifiableListView(
      _messages..sort((Message m1, Message m2) => m1.date.compareTo(m2.date)));

  late StreamSubscription _chatSubscription;
  late StreamSubscription _readSubscription;

  late Timer _timer;
  int? remainSeconds;

  @override
  void dispose() {
    _chatSubscription.cancel();
    _readSubscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> init() async {
    _updateChat();
    _readAll();
    tickTimer();
    listen();
  }

  Future<void> _updateChat() async {
    _messages = await _chatService.getAllMessage(roomId);
    await _readAll();
    notifyListeners();
  }

  Future<void> _readAll() async {
    await _chatService.readAllMessage(roomId, user);
  }

  void listen() {
    final chatStream = _chatService.createMessageRef(roomId).snapshots();

    _chatSubscription = chatStream.listen((event) async {
      _messages = await _chatService.getAllMessage(roomId);
      notifyListeners();
    });

    final readStream = _chatService.roomRef.doc(roomId).snapshots();

    _readSubscription = readStream.listen((event) async {
      _readAll();
    });
  }

  void send(User sender, TextEditingController msg) {
    if (msg.text.isEmpty) return;

    _chatService.addMessage(roomId,
        Message(sender: sender, message: msg.text, date: Timestamp.now()));
    msg.clear();
  }

  void sendSystem(String msg) {
    if (msg.isEmpty) return;

    User system = User(id: 0, nickname: 'system', intra: 'system');

    _chatService.addSystemMessage(
        roomId, Message(sender: system, message: msg, date: Timestamp.now()));
  }

  bool isChangeDate(int i) {
    DateTime prevDate = messages[i - 1].date.toDate();
    DateTime currDate = messages[i].date.toDate();

    return i > 0 && prevDate.day != currDate.day;
  }

  Future<void> tickTimer() async {
    final ChatRoom room = await _chatService.getChatRoom(roomId) as ChatRoom;
    remainSeconds = calculateRemainSeconds(room.open);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainSeconds! > 0) {
        remainSeconds = remainSeconds! - 1;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  int calculateRemainSeconds(Timestamp openTime) {
    int remainSeconds =
        openTime.seconds + (42 * 3600) - Timestamp.now().seconds;

    return remainSeconds > 0 ? remainSeconds : 0;
  }

  String parseHMS() {
    if (remainSeconds == null) return 'Loading...';

    int remain = remainSeconds!;

    int h = remain ~/ 3600;

    remain -= h * 3600;

    int m = remain ~/ 60;

    remain -= m * 60;

    int s = remain;

    return '$h : $m : $s 남음';
  }
}
