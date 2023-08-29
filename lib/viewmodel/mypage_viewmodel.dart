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
  User user;
  String token;
  late List<Interest> interestList;
  InterestService interestService = InterestService.instance;

  MyPageViewModel({required this.user, required this.token}) {
    interestList = [];

    for (String? interest in user.interests) {
      if (interest != null) {
        interestList.add(Interest(interest, true));
      }
    }
    _init();
  }

  Future<void> _init() async {
    List<String> selected =
        await interestService.getInterestsById(user.id, token);

    for (Interest interest in interestList) {
      if (selected.contains(interest.title)) {
        interest.isSelect = true;
      }
    }
    notifyListeners();
  }

  bool checkInterest(String interest, List<String?> interestList) {
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i] == interest) return true;
    }
    return false;
  }

  late List<Interest> isSelect = [
    for (int i = 0; i < allInterest.length; i++)
      Interest(allInterest[i], checkInterest(allInterest[i], user.interests))
  ];

  bool isSelectEnabled(List<Interest> isSelect, int index) {
    return !isSelect[index].isSelect &&
        isSelect.where((element) => element.isSelect).length >= 5;
  }

  void onPressed(int index) {
    if (isSelectEnabled(isSelect, index)) return;

    isSelect[index].isSelect = !isSelect[index].isSelect;
    notifyListeners();
  }

  Future<void> verifyButton({required Function callback}) async {
    List<String> selectedList = isSelect
        .where((Interest interest) => interest.isSelect == true)
        .map((Interest interest) => interest.title)
        .toList();

    User user = await interestService.postInterests(selectedList, token);

    callback(user);
  }
}
