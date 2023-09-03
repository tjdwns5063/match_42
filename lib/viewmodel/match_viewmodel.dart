import 'dart:io';

import 'package:flutter/material.dart';
import 'package:match_42/service/match_service.dart';

enum ChatType { talk, eat, subject }

class MatchViewModel extends ChangeNotifier {
  MatchViewModel(String token) : _token = token;

  MatchService matchService = MatchService.instance;
  final String _token;

  Future<void> matchStart(
      {required ChatType type,
      required int capacity,
      bool isGender = false,
      String projectName = '',
      String footType = ''}) {
    return switch (type) {
      ChatType.talk => matchService.startTalkMatch(capacity, _token),
      // ChatType.eat => matchService.start,
      ChatType.subject =>
        matchService.startSubjectMatch(capacity, projectName, _token),
      _ => Future.error(Exception('ChatType Error')),
    };
  }
}
