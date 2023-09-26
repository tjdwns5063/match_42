import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/user.dart';

import 'chat_room_test.dart';

void checkNicknameTest(User user, String expected) {
  ChatRoom chatRoom = ChatRoomCreator.createGroup();

  user.decideNickname(chatRoom);

  expect(user.nickname, expected);
}

void checkProfileTest(User user, String expected) {
  ChatRoom chatRoom = ChatRoomCreator.createGroup();

  user.decideProfile(chatRoom);

  expect(user.profile, expected);
}

void main() {
  group('user unit test', () {
    Map<User, String> nicknameParam = {
      User(id: 1, intra: '1'): '건',
      User(id: 2, intra: '2'): '곤',
      User(id: 3, intra: '3'): '감',
      User(id: 4, intra: '4'): '리',
      User(id: 5, intra: '5'): '리',
    };

    Map<User, String> profileParam = {
      User(id: 1, intra: '1'): 'gun.png',
      User(id: 2, intra: '2'): 'gon.png',
      User(id: 3, intra: '3'): 'gam.png',
      User(id: 4, intra: '4'): 'lee.png',
      User(id: 5, intra: '5'): 'lee.png',
    };

    nicknameParam.forEach((user, expected) {
      test('유저의 닉네임이 ${nicknameParam[user]}으로 설정 되는지 확인하는 테스트', () {
        checkNicknameTest(user, expected);
      });
    });

    profileParam.forEach((user, expected) {
      test('유저의 프로필이 ${profileParam[user]}으로 설정 되는지 확인하는 테스트', () {
        checkProfileTest(user, expected);
      });
    });
  });
}
