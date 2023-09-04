import 'dart:io';

import 'package:flutter/material.dart';
import 'package:match_42/service/match_service.dart';

enum ChatType {
  talk('수다'),
  eat('밥'),
  subject('과제');

  const ChatType(this.typeName);
  final String typeName;
}

class MatchViewModel extends ChangeNotifier {
  MatchViewModel(String token) : _token = token {
    updateStatus();
  }

  MatchService matchService = MatchService.instance;
  final String _token;
  Map<String, bool> matchStatus = {'밥': false, '수다': false, '과제': false};

  Future<void> updateStatus() async {
    Map<String, dynamic> data = await matchService.getMatchData(_token);

    matchStatus[ChatType.eat.typeName] = data['mealMatchId'] != 0;
    matchStatus[ChatType.subject.typeName] = data['subjectMatchId'] != 0;
    matchStatus[ChatType.talk.typeName] = data['chatMatchId'] != 0;

    print(matchStatus);

    notifyListeners();
  }

  Future<void> matchStart(
      {required ChatType type,
      required int capacity,
      bool isGender = false,
      String projectName = '',
      String menu = ''}) {
    return switch (type) {
      ChatType.talk => matchService.startTalkMatch(capacity, _token),
      ChatType.eat => matchService.startEatMatch(capacity, menu, _token),
      ChatType.subject =>
        matchService.startSubjectMatch(capacity, projectName, _token),
    }
        .then((value) => updateStatus());
  }

  Future<void> matchStop({required ChatType type}) async {
    return switch (type) {
      ChatType.talk => matchService.stopTalkMatch(_token),
      ChatType.eat => matchService.stopEatMatch(_token),
      ChatType.subject => matchService.stopSubjectMatch(_token),
    }
        .then((value) => updateStatus());
  }
}
