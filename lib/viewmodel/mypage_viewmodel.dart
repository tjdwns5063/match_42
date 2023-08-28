import 'package:flutter/cupertino.dart';
import 'package:match_42/ui/my_page.dart';

class MyPageViewModel extends ChangeNotifier {
  List<Interest> interestList = [
    Interest('운동', false),
    Interest('코딩', false),
    Interest('반려동물', false),
  ];

  void onPressed(int index) {
    interestList[index].isSelect = !interestList[index].isSelect;

    notifyListeners();
  }
}