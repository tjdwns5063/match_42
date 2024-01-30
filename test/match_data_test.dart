import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/api/firebase/match_api.dart';
import 'package:match_42/data/block_user.dart';
import 'package:match_42/data/user.dart';

class MatchDataTest {
  void blockUserInBlockList() {
    MatchData match = MatchData(
        id: '',
        capacity: 4,
        matchType: '수다',
        createdAt: Timestamp.now(),
        users: [
          1,
          2,
        ],
        blockUsers: [
          BlockInfo(
            to: BlockUser(id: 3, intra: 'seongjki'),
            from: BlockUser(id: 1, intra: 'sumilee'),
          )
        ]);

    User user = User(
        id: 3,
        nickname: '',
        intra: 'seongjki',
        profile: '',
        reportCount: 0,
        interests: <String>[],
        blockUsers: <BlockInfo>[]);

    bool result = match.isBlocked(user);

    expect(result, true);
  }

  void blockUserAlreadyInMatch() {
    MatchData match = MatchData(
        id: '',
        capacity: 4,
        matchType: '수다',
        createdAt: Timestamp.now(),
        users: [
          1,
          2,
        ],
        blockUsers: <BlockInfo>[]);

    User user = User(
        id: 3,
        nickname: '',
        intra: 'seongjki',
        profile: '',
        reportCount: 0,
        interests: <String>[],
        blockUsers: [
          BlockInfo(
              to: BlockUser(id: 1, intra: 'sumilee'),
              from: BlockUser(id: 3, intra: 'seongjki'))
        ]);

    bool result = match.isBlocked(user);

    expect(result, true);
  }
}

void main() {
  MatchDataTest matchDataTest = MatchDataTest();
  test('block_users에 내가 존재해서 차단되는 경우',
      () => matchDataTest.blockUserInBlockList());
  test('참가자 중 내가 차단한 사람이 있는 경우', () => matchDataTest.blockUserAlreadyInMatch());
}
