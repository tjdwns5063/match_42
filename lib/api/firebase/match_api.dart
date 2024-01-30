import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/token_apis.dart';
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
      required this.users});

  final String id;
  final int capacity;
  final String matchType;
  final Timestamp createdAt;
  final List<int> users;

  int get size => users.length;

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
        id: json['id'],
        capacity: json['capacity'],
        matchType: json['matchType'],
        users: json['users'],
        createdAt: json['createdAt']);
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'capacity': capacity,
      'matchType': matchType,
      'users': users,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'matchType': matchType,
      'ids': users,
      'createdAt': createdAt.toDate().toString(),
    };
  }

  @override
  String toString() {
    return 'id: $id capacity: $capacity matchType: $matchType, users: $users';
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
    QuerySnapshot<MatchData> query = await matchRef
        .where('matchType', isEqualTo: type)
        .where('capacity', isEqualTo: capacity)
        .orderBy('createdAt')
        .get();

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      if (query.size != 0) {
        MatchData matchData = query.docs.first.data();
        DocumentReference<MatchData?> documentReference =
            matchRef.doc(matchData.id);

        matchData.users.add(id);
        transaction.update(documentReference, {'users': matchData.users});

        if (matchData.capacity == matchData.size) {
          //TODO: HttpApis 의존성을 viewModel로 이동시켜야함.
          HttpApis.instance(TokenApis.instance)
              .sendCreateChatNotification(matchData);

          transaction.delete(documentReference);
          _chatService.addChatRoom(ChatRoom(
              id: '',
              name: '$type 채팅방',
              type: type,
              open: Timestamp.now(),
              users: matchData.users,
              unread: List.generate(matchData.capacity, (index) => 0),
              lastMsg: Message(
                  sender: User(id: -1, intra: 'system', reportCount: 0),
                  message: '채팅방이 생성됐습니다.',
                  date: Timestamp.now())));
          return null;
        }
        return (await documentReference.get()).data();
      }

      MatchData matchData = MatchData(
        id: '0',
        capacity: capacity,
        matchType: type,
        users: <int>[id],
        createdAt: Timestamp.now(),
      );

      DocumentReference<MatchData?> documentReference =
          await matchRef.add(matchData);

      return (await documentReference.get()).data();
    });
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
      transaction.update(documentReference, {'users': matchData.users});

      if (matchData.users.isEmpty) {
        transaction.delete(documentReference);
        return null;
      }

      return (await documentReference.get()).data();
    });
  }
}
