import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/service/chat_service.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'matchType': matchType,
      'users': users,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'id: $id capacity: $capacity matchType: $matchType, users: $users';
  }
}

const String _matchCollectionPath = 'match';

class MatchService {
  MatchService._();

  static final MatchService instance = MatchService._();

  final ChatService _chatService = ChatService.instance;

  final CollectionReference<MatchData> matchRef = FirebaseFirestore.instance
      .collection(_matchCollectionPath)
      .withConverter(
          fromFirestore: MatchData.fromFirestore,
          toFirestore: (MatchData data, options) => data.toJson());

  Future<MatchData?> startMatch(int capacity, String type, int id) async {
    print('type: $type');
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      QuerySnapshot<MatchData> query = await matchRef
          .where('matchType', isEqualTo: type)
          .orderBy('createdAt')
          .get();

      if (query.size != 0) {
        MatchData matchData = query.docs.first.data();

        matchData.users.add(id);
        await matchRef.doc(matchData.id).update({'users': matchData.users});

        if (matchData.capacity == matchData.size) {
          await matchRef.doc(matchData.id).delete();
          _chatService.addChatRoom(ChatRoom(
              id: '',
              name: '$type 채팅방',
              type: type,
              open: Timestamp.now(),
              users: matchData.users,
              unread: List.generate(matchData.capacity, (index) => 0),
              lastMsg: Message(
                  sender: User(id: -1, intra: 'system'),
                  message: '채팅방이 생성됐습니다.',
                  date: Timestamp.now())));
        }

        return (await matchRef.doc(matchData.id).get()).data();
      }

      MatchData matchData = MatchData(
        id: '0',
        capacity: capacity,
        matchType: type,
        users: <int>[id],
        createdAt: Timestamp.now(),
      );

      return (await (await matchRef.add(matchData)).get()).data() as MatchData;
    });
  }

  Future<MatchData?> stopMatch(int id, String type) async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      QuerySnapshot<MatchData> query = await matchRef
          .where('matchType', isEqualTo: type)
          .where('users', arrayContains: id)
          .get();

      MatchData? matchData = query.docs.firstOrNull?.data();

      if (matchData == null) return null;

      matchData.users.remove(id);
      await matchRef.doc(matchData.id).update({'users': matchData.users});
      if (matchData.users.isEmpty) {
        await matchRef.doc(matchData.id).delete();
      }

      return (await matchRef.doc(matchData.id).get()).data();
    });
  }

  Future<Map<String, MatchData?>> getMatchData(int id) async {
    QuerySnapshot<MatchData> query =
        await matchRef.where('users', arrayContains: id).get();

    List<MatchData> results = query.docs.map((e) => e.data()).toList();

    if (results.length > 3) {
      return Future.error(Exception('최대 매치 개수를 초과했습니다. (${results.length}개'));
    }

    return {
      '밥': results.where((element) => element.matchType == '밥').firstOrNull,
      '수다': results.where((element) => element.matchType == '수다').firstOrNull,
      '과제': results.where((element) => element.matchType == '과제').firstOrNull
    };
  }
}
