import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RemainTimer {
  RemainTimer({required Timestamp openTime, required this.notify})
      : _remainTime = calculateRemainSeconds(openTime) {
    startTimer();
  }

  int get remainTime => _remainTime;
  int _remainTime;
  Function notify;

  late Timer timer;

  static int calculateRemainSeconds(Timestamp openTime) {
    int remainSeconds =
        openTime.seconds + (42 * 3600) - Timestamp.now().seconds;

    return remainSeconds > 0 ? remainSeconds : 0;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainTime > 0) {
        _remainTime = _remainTime - 1;
      } else {
        timer.cancel();
      }
      notify();
    });
  }
}
