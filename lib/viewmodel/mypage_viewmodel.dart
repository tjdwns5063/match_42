import 'package:flutter/cupertino.dart';
import 'package:match_42/service/block_service.dart';
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
  '외국어',
  '식물',
  '비건',
  '맛집탐방',
  '웹툰',
  '카페',
  '댄스',
  '아이돌',
  '캠핑',
  '사진',
  '패션',
  '투자',
  '철학',
  '그림',
  '자기계발',
  '악기',
  '종교',
  '전자기기',
  '쇼핑',
  '애니메이션'
];

class MyPageViewModel extends ChangeNotifier {
  String token;
  final InterestService _interestService;
  final BlockService _blockService;

  late List<Interest> interestList;
  late List<Interest> selectedList;
  late List<String> blockUsers;

  MyPageViewModel(BlockService blockService, InterestService interestService,
      {user, required this.token})
      : _blockService = blockService,
        _interestService = interestService {
    _initInterestList(user);
    _initSelectedList();
    _initBlockUsers(user);
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

  void _initBlockUsers(User user) {
    blockUsers = user.blockUsers;
  }

  bool checkInterest(String interest, List<String?> interestList) {
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i] == interest) return true;
    }
    return false;
  }

  void onSelect(int index) {
    if (_isSelectEnabled(index)) return;

    selectedList[index].isSelect = !selectedList[index].isSelect;
    notifyListeners();
  }

  bool _isSelectEnabled(int index) {
    return !selectedList[index].isSelect &&
        selectedList.where((element) => element.isSelect).length >= 5;
  }

  Future<void> requestPutInterests({required Function callback}) async {
    List<String> selected = selectedList
        .where((Interest interest) => interest.isSelect)
        .map((Interest interest) => interest.title)
        .toList();

    User user = await _interestService.postInterests(selected, token);

    callback(user);
    _initInterestList(user);

    notifyListeners();
  }

  Future<void> requestAddBlockUser(
      {required String intraId, required Function callback}) async {
    User user = await _blockService.addBlockUser(intraId, token);

    callback(user);
    _initBlockUsers(user);

    notifyListeners();
  }

  Future<void> requestDeleteBlockUser(
      {required int index, required Function callback}) async {
    User user = await _blockService.deleteBlockUser(blockUsers[index], token);

    callback(user);
    _initBlockUsers(user);

    notifyListeners();
  }
}
