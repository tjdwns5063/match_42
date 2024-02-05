import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class RemainTimer {
  RemainTimer({required Timestamp openTime, required this.notify})
      : _endTime = openTime.toDate().add(const Duration(hours: 42)) {
    startTimer();
  }

  final DateTime _endTime;
  Duration get remainTime => _calculateRemainSeconds(_endTime);

  Function notify;

  late Timer timer;

  static Duration _calculateRemainSeconds(DateTime endTime) {
    return endTime.difference(DateTime.now());
  }

  String parseRemainTime() {
    if (remainTime.inMilliseconds <= 0) return '00:00:00';
    return remainTime.toString().substring(0, 8);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainTime.compareTo(Duration(seconds: 0)) > 0) {
        _calculateRemainSeconds(_endTime);
      } else {
        timer.cancel();
      }
      notify();
    });
  }
}
