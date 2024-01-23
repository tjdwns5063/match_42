import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:match_42/service/match_service.dart';

class MatchViewModel extends ChangeNotifier {
  MatchViewModel(this._id, this._token) {
    init();
  }

  MatchService matchService = MatchService.instance;
  final int _id;
  final String _token;

  Map<String, MatchData?> matchStatus = {'밥': null, '수다': null, '과제': null};

  Map<String, bool> get matching =>
      matchStatus.map((key, value) => MapEntry(key, isMatching(key)));

  late StreamSubscription streamSubscription;

  Future<void> init() async {
    streamSubscription =
        matchService.matchRef.snapshots().listen((event) async {
      var results = event.docs
          .where((e) => e.data().users.contains(_id))
          .map((e) => e.data())
          .toList();

      matchStatus = Map.fromEntries(
        ChatType.values.map(
          (e) => MapEntry(
              e.typeName,
              results
                  .where((element) => element.matchType == e.typeName)
                  .firstOrNull),
        ),
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  bool isMatching(String type) {
    if (matchStatus[type] == null) return false;

    return matchStatus[type]!.capacity > matchStatus[type]!.size;
  }

  Future<void> matchStart(
      {required ChatType type,
      required int capacity,
      bool isGender = false,
      String projectName = '',
      String menu = ''}) async {
    matchStatus[type.typeName] = await FirebaseFirestore.instance
        .runTransaction((transaction) =>
            matchService.startMatch(capacity, type.typeName, _id, _token));
  }

  Future<void> matchStop({required ChatType type}) async {
    matchStatus[type.typeName] =
        await matchService.stopMatch(_id, type.typeName);
  }
}

enum ChatType {
  chat('수다'),
  meal('밥'),
  subject('과제');

  const ChatType(this.typeName);
  final String typeName;
}
