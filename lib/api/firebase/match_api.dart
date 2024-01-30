import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/token_apis.dart';
import 'package:match_42/data/block_user.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/api/firebase/chat_api.dart';

class MatchData {
  MatchData(
      {required this.id,
      required this.capacity,
      required this.matchType,
      required this.createdAt,
      required this.users,
      required this.blockUsers});

  final String id;
  final int capacity;
  final String matchType;
  final Timestamp createdAt;
  final List<int> users;
  final List<BlockInfo> blockUsers;

  int get size => users.length;

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
        id: json['id'],
        capacity: json['capacity'],
        matchType: json['matchType'],
        users: json['users'],
        createdAt: json['createdAt'],
        blockUsers: json['blockUsers']);
  }

  factory MatchData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final Map<String, dynamic> data = snapshot.data()!;

    return MatchData(
        id: snapshot.id,
        capacity: data['capacity'],
        matchType: data['matchType'],
        users: List<int>.from(data['users']),
        createdAt: data['createdAt'],
        blockUsers: List.from(data['blockUsers'])
            .map((e) => BlockInfo.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toFirestore() {
    return {
      'capacity': capacity,
      'matchType': matchType,
      'users': users,
      'createdAt': createdAt,
      'blockUsers': blockUsers.map((e) => e.toFirestore()).toList()
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'matchType': matchType,
      'ids': users,
      'createdAt': createdAt.toDate().toString(),
      'blockUsers': blockUsers
    };
  }

  @override
  String toString() {
    return 'id: $id capacity: $capacity matchType: $matchType, users: $users, blockUsers: $blockUsers';
  }

  bool isBlocked(User user) {
    bool isUserInBlockUsers = blockUsers
        .any((element) => element.to.id == user.id); // blockUsers에 내가 있는지

    bool isBlockUsersInUsers = users
        .toSet()
        .intersection(user.blockUsers.map((e) => e.to.id).toSet())
        .isNotEmpty; // 참가자 중 내가 차단한 사람이 있는지

    return isUserInBlockUsers || isBlockUsersInUsers;
  }
}

const String _matchCollectionPath = 'match';

class MatchApis {
  MatchApis._();

  static final MatchApis instance = MatchApis._();

  final ChatApis _chatService = ChatApis.instance;

  final CollectionReference<MatchData> matchRef = FirebaseFirestore.instance
      .collection(_matchCollectionPath)
      .withConverter(
          fromFirestore: MatchData.fromFirestore,
          toFirestore: (MatchData data, options) => data.toFirestore());

  Future<MatchData?> startMatch(int capacity, String type, int id) async {
    QuerySnapshot<MatchData> query = (await matchRef
        .where('matchType', isEqualTo: type)
        .where('capacity', isEqualTo: capacity)
        .orderBy('createdAt')
        .get());

    User user = await HttpApis.instance(TokenApis.instance).getUser();

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        MatchData matchData = query.docs
            .firstWhere((element) => !element.data().isBlocked(user))
            .data();
        DocumentReference<MatchData?> documentReference =
            participateMatch(matchData, user, transaction);

        if (isMatch(matchData)) {
          createChatRoomAndRemoveMatch(
              matchData, transaction, documentReference, type);
        }
        return (await documentReference.get()).data();
      } catch (err, stack) {
        return (await createNewMatch(capacity, type, user)).data();
      }
    });
  }

  DocumentReference<MatchData?> participateMatch(
      MatchData matchData, User user, Transaction transaction) {
    DocumentReference<MatchData?> documentReference =
        matchRef.doc(matchData.id);

    matchData.users.add(user.id);
    matchData.blockUsers.addAll(user.blockUsers);
    transaction.update(documentReference, {
      'users': matchData.users,
      'blockUsers': matchData.blockUsers.map((e) => e.toFirestore())
    });
    return documentReference;
  }

  bool isMatch(MatchData matchData) => matchData.capacity == matchData.size;

  void createChatRoomAndRemoveMatch(
      MatchData matchData,
      Transaction transaction,
      DocumentReference<MatchData?> documentReference,
      String type) {
    //TODO: HttpApis 의존성을 viewModel로 이동시켜야함.
    HttpApis.instance(TokenApis.instance).sendCreateChatNotification(matchData);

    transaction.delete(documentReference);
    _chatService.addChatRoom(ChatRoom(
        id: '',
        name: '$type 채팅방',
        type: type,
        open: Timestamp.now(),
        users: matchData.users,
        unread: List.generate(matchData.capacity, (index) => 0),
        lastMsg: Message(
            sender: User(
                id: -1,
                intra: 'system',
                reportCount: 0,
                blockUsers: <BlockInfo>[]),
            message: '채팅방이 생성됐습니다.',
            date: Timestamp.now())));
  }

  Future<DocumentSnapshot<MatchData?>> createNewMatch(
      int capacity, String type, User user) async {
    MatchData matchData = MatchData(
        id: '0',
        capacity: capacity,
        matchType: type,
        users: <int>[user.id],
        createdAt: Timestamp.now(),
        blockUsers: user.blockUsers);

    DocumentReference<MatchData?> documentReference =
        await matchRef.add(matchData);

    return documentReference.get();
  }

  Future<MatchData?> stopMatch(int id, String type) async {
    QuerySnapshot<MatchData> query = await matchRef
        .where('matchType', isEqualTo: type)
        .where('users', arrayContains: id)
        .get();

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      MatchData? matchData = query.docs.firstOrNull?.data();

      if (matchData == null) return null;

      DocumentReference<MatchData?> documentReference =
          matchRef.doc(matchData.id);

      matchData.users.remove(id);
      matchData.blockUsers.removeWhere((element) => element.from.id == id);
      transaction.update(documentReference,
          {'users': matchData.users, 'blockUsers': matchData.blockUsers});

      if (matchData.users.isEmpty) {
        transaction.delete(documentReference);
      }

      return (await documentReference.get()).data();
    });
  }
}
