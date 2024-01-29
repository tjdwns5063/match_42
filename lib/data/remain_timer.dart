import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class RemainTimer {
  RemainTimer({required Timestamp openTime, required this.notify})
      : _remainTime = _calculateRemainSeconds(openTime) {
    initializeDateFormatting();
    startTimer();
  }

  int get remainTime => _remainTime;
  int _remainTime;
  Function notify;

  late Timer timer;

  static int _calculateRemainSeconds(Timestamp openTime) {
    int remainSeconds =
        openTime.seconds + (42 * 3600) - Timestamp.now().seconds;

    return remainSeconds > 0 ? remainSeconds : 0;
  }

  String parseRemainTime() {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
        Duration(seconds: _remainTime).inMilliseconds);

    return DateFormat.Hms().format(time);
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
