import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/remain_timer.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/user_service.dart';

const List<String> topics = [
  '서로의 취미에 대해 얘기해보세요.',
  '본과정에서 가장 힘들었던 순간에 대해 얘기해보세요.',
  '코딩을 하며 성취감을 느꼈던 순간에 대해 얘기해보세요.',
  '코딩에 관심을 가지게 된 계기에 대해 얘기해보세요.',
  '최근 즐겨보는 유튜브나 넷플릭스 영상에 대해 얘기해보세요.',
  '클러스터 근처에서 맛있게 먹었던 메뉴에 대해 얘기해보세요.',
  '좋아하는 영화에 대해 얘기해보세요.',
  '요즘 즐겨듣는 음악에 대해 얘기해보세요.',
  '가장 힘들었던 과제에 대해 얘기해보세요.',
  '서로에게 좋았던 책 한 권씩을 추천해주세요.',
  '자신의 패션에 대해 얘기해보세요.',
  '여가시간에 주로 무엇을 하며 시간을 보내는지 얘기해보세요.',
  '최근 새로 생긴 관심사가 있다면 얘기해보세요.',
  '여행 계획이나 다녀왔던 여행에 대해 얘기해보세요.',
  '좋아하는 음식에 대해 얘기해보세요.',
  '어제 하루 어떻게 보냈는지에 대해 얘기해보세요.',
  '가장 단기적인 목표에 대해서 얘기해보세요.',
  '서로의 꿈에 대해 얘기해보세요.',
  '최근 가장 즐거웠던 순간에 대해 얘기해보세요.',
  '자신의 장점에 대해 얘기해보세요.',
  '새롭게 배워보고 싶은 분야에 대해 얘기해보세요.',
  '좋아하는 게임에 대해 얘기해보세요.',
  '끝말잇기를 해서 5번째로 나온 단어에 대해 얘기해보세요.',
  '내일의 계획에 대해 얘기해보세요.',
  '최근 만족스러웠던 소비에 대해 얘기해보세요.',
  '어릴 적 꿈에 대해 얘기해보세요.',
  '요즘 사고싶은 물건에 대해 얘기해보세요.',
  '로또 1등에 당첨된다면 무엇을 하고싶은지 얘기해보세요.',
  '노년에 어떤 삶을 살고싶은지 얘기해보세요.',
  '서로의 버킷리스트에 대해 얘기해보세요.',
  '최근 하고있는 고민에 대해 얘기해보세요.',
  '요즘 나를 즐겁게 해주는 것들에 대해 얘기해보세요.',
];

class ChatViewModel extends ChangeNotifier {
  ChatViewModel(
      {required this.roomId,
      required this.user,
      required this.token,
      required ChatService chatService,
      required UserService userService})
      : _chatService = chatService,
        _userService = userService,
        _chatRoom = ChatRoom(
            id: roomId,
            name: '',
            type: '',
            open: Timestamp.now(),
            users: [1, 2],
            unread: [0, 0],
            lastMsg:
                Message(sender: user, message: '', date: Timestamp.now())) {
    init();
  }

  final String roomId;

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
      List<Message> newMessages = [];
      for (QueryDocumentSnapshot<Message> doc in event.docs) {
        newMessages.add(doc.data());
      }
      _messages = newMessages;
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
    _userService.sendChatNotification({
      'id': chatRoom.id,
      'name': chatRoom.name,
      'userIds': chatRoom.users,
    }, '${(chatRoom.type.toLowerCase() == 'chat') ? sender.nickname : sender.intra}: $text',
        token);
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

  Future<void> _sendSystem(String msg) async {
    if (msg.isEmpty) return;

    User system = User(id: 0, nickname: 'system', intra: 'system');

    await _chatService.addMessage(chatRoom.id,
        Message(sender: system, message: msg, date: Timestamp.now()));
  }

  Future<void> updateOpenResult() async {
    _chatRoom.updateIsOpen(user.id);
    await _chatService.updateIsOpen(chatRoom);

    if (_chatRoom.isEveryOpened()) {
      await _sendMatchMessage();
    }
    notifyListeners();
  }

  Future<void> _sendMatchMessage() async {
    print('send MatchMessage');
    _userService.sendMatchNotification({
      'ids': chatRoom.users,
    }, token);
  }

  Future<void> _addMessage(Message msg) async {
    _chatRoom.addUnreadMessage(msg);
    _chatRoom.lastMsg = msg;

    await _chatService.updateChatRoom(_chatRoom);
    await _chatService.addMessage(chatRoom.id, msg);
  }

  Future<void> _readAll() async {
    _chatRoom.readAll(user.id);

    await _chatService.updateUnread(_chatRoom);
  }

  bool isRemainTime() {
    return (timer?.remainTime ?? 42 * 3600) > 0;
  }

  Future<void> makeTopic() async {
    int index = Random(DateTime.now().millisecond).nextInt(topics.length);
    await _sendSystem(topics[index]);
  }
}
