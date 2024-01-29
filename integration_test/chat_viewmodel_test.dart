import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/api/firebase/chat_api.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test/chat_room_test.dart';
import 'FirebaseSetter.dart';

@GenerateNiceMocks([MockSpec<HttpApis>()])
import 'chat_viewmodel_test.mocks.dart';

class ChatViewModelTest {
  late User me;
  late MockHttpApis httpApis;
  late ChatApis chatApis;

  late ChatRoom chatRoom;
  late ChatViewModel chatViewModel;

  Future<void> init() async {
    me = User(id: 1, nickname: '', intra: 'seongjki', profile: '');
    httpApis = MockHttpApis();
    chatApis = ChatApis.instance;
    chatRoom = ChatRoomCreator.create();
    final ref = await chatApis.addChatRoom(chatRoom);

    chatViewModel = ChatViewModel(
        roomId: ref.id, user: me, chatService: chatApis, httpApis: httpApis);
  }

  Future<void> sendMessageTest() async {
    await chatViewModel.send(me, TextEditingController(text: 'hello'));

    expect(chatViewModel.messages[0].message, 'hello');
    verify(httpApis.sendChatNotification({
      'id': chatViewModel.chatRoom.id,
      'name': chatViewModel.chatRoom.name,
      'userIds': chatViewModel.chatRoom.users,
      'msg': 'seongjki: hello'
    })).called(1);
  }

  Future<void> whenRemainTimeZeroAllUserDecideOpenIdTest() async {
    chatViewModel.chatRoom.updateIsOpen(2);

    await chatViewModel.updateOpenResult();

    print('isEveryOpened = ${chatViewModel.chatRoom.isEveryOpened()}');

    expect(chatViewModel.chatRoom.isEveryOpened(), true);
    verifyInOrder([
      httpApis.sendMatchNotification({
        'ids': chatRoom.users,
      }),
    ]);
  }

  Future<void> conversationTopicRecommendationTest() async {
    await chatViewModel.makeTopic();

    String result =
        (await chatApis.getAllMessage(chatViewModel.chatRoom.id)).last.message;

    expect(topics.contains(result), true);
  }
}

Future<void> main() async {
  await FirebaseSetter.init();
  ChatViewModelTest chatViewModelTest = ChatViewModelTest();

  setUp(() async {
    await FirebaseSetter.deleteFirestore();
    await chatViewModelTest.init();
  });

  tearDown(() async {
    chatViewModelTest.chatViewModel.dispose();
    await FirebaseSetter.deleteFirestore();
  });

  group('chat viewmodel test', () {
    test('메세지 전송 기능 테스트', () => chatViewModelTest.sendMessageTest());
    test('채팅 시간이 끝난 후, 모두 아이디 공개를 결정한 경우를 테스트',
        () => chatViewModelTest.whenRemainTimeZeroAllUserDecideOpenIdTest());
    test('대화 주제 추천 기능 테스트',
        () => chatViewModelTest.conversationTopicRecommendationTest());
  });
}
