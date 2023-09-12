import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/user_service.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([MockSpec<UserService>()])
import 'chat_viewmodel_test.mocks.dart';

Future<void> deleteFirestore() async {
  Uri uri = Uri.http('10.0.2.2:8080',
      '/emulator/v1/projects/match-42/databases/(default)/documents');

  http.Response response =
      await http.delete(uri, headers: {'Authorization': 'Bearer owner'});

  if (response.statusCode != 200) {
    print('Firestore clear failed!');
  }
}

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .useFirestoreEmulator('localhost', 8080, sslEnabled: false);
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    deleteFirestore();
  });

  test('when send message, check adding message successfully', () async {
    User user = User(id: 1, nickname: '', intra: 'seongjki', profile: '');
    TextEditingController textEditingController =
        TextEditingController(text: 'hello');
    UserService userService = MockUserService();
    ChatRoom chatRoom = ChatRoom(
        id: '',
        name: 'test',
        type: 'meal',
        open: Timestamp.now(),
        users: [1, 2],
        unread: [0, 0],
        lastMsg: Message(
            sender: User(id: 0, nickname: '', intra: ''),
            message: 'hi',
            date: Timestamp.now()));

    ChatService chatService = ChatService.instance;

    DocumentReference<ChatRoom> ref = await chatService.addChatRoom(chatRoom);

    ChatViewModel chatViewModel = ChatViewModel(
        roomId: ref.id,
        user: user,
        token: 'token',
        chatService: chatService,
        userService: userService);

    await chatViewModel.send(user, textEditingController);
    expect(chatViewModel.messages[0].message, 'hello');
  }, onPlatform: {'browser': Skip(), 'windows': Skip(), 'linux': Skip()});
}
