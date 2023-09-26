import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/user_service.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test/chat_room_test.dart';
import 'FirebaseSetter.dart';
@GenerateNiceMocks([MockSpec<UserService>()])
import 'chat_viewmodel_test.mocks.dart';

class ChatViewModelTest {
  late User me;
  late MockUserService userService;
  late ChatService chatService;
  late ChatRoom chatRoom;
  late ChatViewModel chatViewModel;

  Future<void> init() async {
    me = User(id: 1, nickname: '', intra: 'seongjki', profile: '');
    userService = MockUserService();
    chatService = ChatService.instance;
    chatRoom = ChatRoomCreator.create();
    final ref = await chatService.addChatRoom(chatRoom);

    chatViewModel = ChatViewModel(
        roomId: ref.id,
        user: me,
        token: 'token',
        chatService: chatService,
        userService: userService);
  }

  Future<void> sendMessageTest() async {
    await chatViewModel.send(me, TextEditingController(text: 'hello'));

    expect(chatViewModel.messages[0].message, 'hello');
    verify(userService.sendNotification(2, 'seongjki: hello', 'token'));
  }

  Future<void> whenRemainTimeZeroAllUserDecideOpenIdTest() async {
    when(userService.getUserIntraNames([1, 2], 'token'))
        .thenAnswer((_) => Future.value(['seongjki', 'jiheekan']));

    chatViewModel.chatRoom.updateIsOpen(2);

    await chatViewModel.updateOpenResult();

    expect(chatViewModel.chatRoom.isEveryOpened(), true);
    verifyInOrder([
      userService.getUserIntraNames([1, 2], 'token'),
      userService.sendNotification(1, 'seongjki, jiheekan 님이 매치되었습니다', 'token'),
      userService.sendNotification(2, 'seongjki, jiheekan 님이 매치되었습니다', 'token')
    ]);
  }

  Future<void> conversationTopicRecommendationTest() async {
    await chatViewModel.makeTopic();

    expect(topics.contains(chatViewModel.messages[0].message), true);
  }
}

Future<void> main() async {
  await FirebaseSetter.init();
  ChatViewModelTest chatViewModelTest = ChatViewModelTest();

  setUp(() async {
    await FirebaseSetter.deleteFirestore();
    await chatViewModelTest.init();
  });

  tearDown(() => chatViewModelTest.chatViewModel.dispose());

  group('chat viewmodel test', () {
    test('메세지 전송 기능 테스트', () => chatViewModelTest.sendMessageTest());
    test('채팅 시간이 끝난 후, 모두 아이디 공개를 결정한 경우를 테스트',
        () => chatViewModelTest.whenRemainTimeZeroAllUserDecideOpenIdTest());
    test('대화 주제 추천 기능 테스트',
        () => chatViewModelTest.conversationTopicRecommendationTest());
  });
}
