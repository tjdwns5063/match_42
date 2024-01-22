import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:match_42/service/match_service.dart';

class MatchViewModel extends ChangeNotifier {
  MatchViewModel(this._id) {
    init();
  }

  MatchService matchService = MatchService.instance;
  final int _id;

  Map<String, MatchData?> matchStatus = {'밥': null, '수다': null, '과제': null};

  Map<String, bool> get matching =>
      matchStatus.map((key, value) => MapEntry(key, isMatching(key)));

  Future<void> init() async {
    Map<String, dynamic> datas = await matchService.getMatchData(_id);

    for (MapEntry<String, dynamic> entry in datas.entries) {
      if (entry.value == null) continue;

      String key = switch (entry.key) {
        'mealMatchId' => ChatType.meal.typeName,
        'subjectMatchId' => ChatType.subject.typeName,
        _ => ChatType.chat.typeName,
      };
      matchStatus = await matchService.getMatchData(_id);

      notifyListeners();
    }
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
            matchService.startMatch(capacity, type.typeName, _id));

    notifyListeners();
  }

  Future<void> matchStop({required ChatType type}) async {
    matchStatus[type.typeName] = await FirebaseFirestore.instance
        .runTransaction(
            (transaction) => matchService.stopMatch(_id, type.typeName));
    notifyListeners();
  }
}

enum ChatType {
  chat('수다'),
  meal('밥'),
  subject('과제');

  const ChatType(this.typeName);
  final String typeName;
}
