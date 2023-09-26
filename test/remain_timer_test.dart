import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/data/remain_timer.dart';

void parseRemainTimeTest() {
  RemainTimer remainTimer = RemainTimer(
      openTime: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(minutes: 1))),
      notify: () {});

  String result = remainTimer.parseRemainTime();

  expect(result, '41 : 59 : 0 남음');
}

void main() {
  test('적절하게 남은 시간을 형식에 맞게 파싱하는지 테스트', () => parseRemainTimeTest());
}
