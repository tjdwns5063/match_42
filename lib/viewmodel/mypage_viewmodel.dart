import 'package:flutter/cupertino.dart';
import 'package:match_42/service/interest_service.dart';
import 'package:match_42/ui/my_page.dart';
import 'package:match_42/data/user.dart';

const List<String> allInterest = [
  '운동',
  '코딩',
  '반려동물',
  'mbti',
  '독서',
  '영화',
  '사업',
  '42서울',
  '취업',
  '게임',
  '여행',
  '외국어'
];

class MyPageViewModel extends ChangeNotifier {
  String token;
  InterestService interestService = InterestService.instance;
  late List<Interest> interestList;
  late List<Interest> selectedList;

  MyPageViewModel({user, required this.token}) {
    _initInterestList(user);
    _initSelectedList();
    notifyListeners();
  }

  void _initInterestList(User user) {
    List<Interest> newInterestList = [];

    for (String? interest in user.interests) {
      if (interest != null) {
        newInterestList.add(Interest(interest, true));
      }
    }
    interestList = newInterestList;
  }

  void _initSelectedList() {
    List<Interest> newSelectedList = allInterest
        .map((String title) => Interest(title,
            interestList.any((Interest interest) => interest.title == title)))
        .toList();

    selectedList = newSelectedList;
  }

  bool checkInterest(String interest, List<String?> interestList) {
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i] == interest) return true;
    }
    return false;
  }

  void onPressed(int index) {
    if (isSelectEnabled(index)) return;

    selectedList[index].isSelect = !selectedList[index].isSelect;
    notifyListeners();
  }

  bool isSelectEnabled(int index) {
    return !selectedList[index].isSelect &&
        selectedList.where((element) => element.isSelect).length >= 5;
  }

  Future<void> verifyButton({required Function callback}) async {
    List<String> selected = selectedList
        .where((Interest interest) => interest.isSelect)
        .map((Interest interest) => interest.title)
        .toList();

    User user = await interestService.postInterests(selected, token);

    callback(user);
    _initInterestList(user);

    notifyListeners();
  }
}
