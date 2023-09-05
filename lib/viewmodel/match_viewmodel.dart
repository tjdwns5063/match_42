import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:match_42/service/chat_service.dart';
import 'package:match_42/service/match_service.dart';

enum ChatType {
  chat('수다'),
  meal('밥'),
  subject('과제');

  const ChatType(this.typeName);
  final String typeName;
}

class MatchViewModel extends ChangeNotifier {
  MatchViewModel(String token) : _token = token {
    init();
    // updateStatus();
  }

  MatchService matchService = MatchService.instance;
  final String _token;
  Map<String, StreamSubscription<DocumentSnapshot<MatchData>>?>
      matchSubscription = {'밥': null, '수다': null, '과제': null};
  Map<String, MatchData?> matchStatus = {'밥': null, '수다': null, '과제': null};
  Map<String, bool> get matching =>
      matchStatus.map((key, value) => MapEntry(key, isMatching(key)));

  Future<void> init() async {
    Map<String, dynamic> ids = await matchService.getMatchData(_token);

    for (MapEntry<String, dynamic> entry in ids.entries) {
      if (entry.value == 0) continue;

      String key = switch (entry.key) {
        'mealMatchId' => ChatType.meal.typeName,
        'subjectMatchId' => ChatType.subject.typeName,
        _ => ChatType.chat.typeName,
      };
      matchStatus[key] =
          await matchService.getMatchDataById(entry.value, _token);

      matchService.matchRef
          .doc(matchStatus[key]!.firebaseMatchId)
          .snapshots()
          .listen((event) {
        print('event called1 ${event.data()}');
        matchStatus[key] = event.data();
        print('1111 ${matchStatus[key]}');
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    for (MapEntry<String,
            StreamSubscription<DocumentSnapshot<MatchData>>?> entry
        in matchSubscription.entries) {
      entry.value?.cancel();
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
    return switch (type) {
      ChatType.chat => matchService.startTalkMatch(capacity, _token),
      ChatType.meal => matchService.startEatMatch(capacity, menu, _token),
      ChatType.subject =>
        matchService.startSubjectMatch(capacity, projectName, _token),
    }
        .then((value) {
      if (matchSubscription[type.typeName] == null) {
        matchSubscription[type.typeName] = matchService.matchRef
            .doc(value.firebaseMatchId)
            .snapshots()
            .listen((event) {
          MatchData? data = event.data();
          print('event called2 ${event.data()}');
          print('222 ${matchStatus[type.typeName]}');

          if (data != null && data.capacity <= data.size) {
            matchService.matchRef
                .doc(matchStatus[type.typeName]?.firebaseMatchId)
                .delete();
            matchSubscription[type.typeName]?.cancel();
            matchSubscription[type.typeName] = null;
          }
          matchStatus[type.typeName] = event.data();
          notifyListeners();
        });
      }
    });
  }

  Future<void> matchStop({required ChatType type}) async {
    return switch (type) {
      ChatType.chat => matchService.stopTalkMatch(_token),
      ChatType.meal => matchService.stopEatMatch(_token),
      ChatType.subject => matchService.stopSubjectMatch(_token),
    }
        .then((value) {
      matchService.matchRef
          .doc(matchStatus[type.typeName]?.firebaseMatchId)
          .delete();
      matchSubscription[type.typeName]?.cancel();
      matchSubscription[type.typeName] = null;
      matchStatus[type.typeName] = null;

      notifyListeners();
    });
  }
}
