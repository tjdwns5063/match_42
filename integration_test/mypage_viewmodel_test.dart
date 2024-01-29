import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/token_apis.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:match_42/viewmodel/mypage_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'FirebaseSetter.dart';
@GenerateNiceMocks([MockSpec<HttpApis>()])
import 'mypage_viewmodel_test.mocks.dart';

class MyPageViewModelTest {
  late User user;
  late MyPageViewModel myPageViewModel;
  late MockHttpApis mockHttpApis;
  late Random random = Random(DateTime.now().millisecond);

  void init(User user) {
    user = user;
    mockHttpApis = MockHttpApis();
    myPageViewModel = MyPageViewModel(mockHttpApis, user: user);
  }

  List<int> _generateSelectIndex(int cnt) {
    Set<int> set = {};

    while (set.length < cnt) {
      set.add(random.nextInt(allInterest.length));
    }

    List<int> ret = set.toList();
    ret.sort();
    return ret;
  }

  Future<void> addInterestSuccessTest(int cnt) async {
    init(User(id: 1, intra: 'seongjki', interests: <String>[]));
    List<int> selectedIndex = _generateSelectIndex(cnt);
    List<String> interestList = [
      for (int index in selectedIndex) allInterest[index]
    ];
    LoginViewModel loginViewModel = LoginViewModel(
        TokenApis.instance, HttpApis.instance(TokenApis.instance));

    for (int index in selectedIndex) {
      myPageViewModel.selectedList[index].isSelect = true;
    }

    when(mockHttpApis.postInterests(interestList)).thenAnswer(
        (_) async => User(id: 1, intra: 'seongjki', interests: interestList));

    await myPageViewModel.requestPutInterests(
        callback: loginViewModel.updateUser);

    expect(myPageViewModel.interestList.length, cnt);
    expect(myPageViewModel.interestList.every((element) => element.isSelect),
        true);
    expect(loginViewModel.user!.interests, interestList);

    loginViewModel.dispose();
    myPageViewModel.dispose();
  }

  Future<void> clearInterestTest(int cnt) async {
    List<int> selectedIndex = _generateSelectIndex(5);
    List<String> interestList = [
      for (int index in selectedIndex) allInterest[index]
    ];
    init(User(id: 1, intra: 'seongjki', interests: interestList));

    LoginViewModel loginViewModel = LoginViewModel(
        TokenApis.instance, HttpApis.instance(TokenApis.instance));

    for (int i = 0; i < cnt; ++i) {
      int selectIndex = selectedIndex[i];
      myPageViewModel.selectedList[selectIndex].isSelect = false;
    }
    interestList.removeRange(0, cnt);

    when(mockHttpApis.postInterests(interestList)).thenAnswer(
        (_) async => User(id: 1, intra: 'seongjki', interests: interestList));

    await myPageViewModel.requestPutInterests(
        callback: loginViewModel.updateUser);

    expect(myPageViewModel.interestList.length, 5 - cnt);
    expect(myPageViewModel.interestList.every((element) => element.isSelect),
        true);
    expect(loginViewModel.user!.interests, interestList);

    loginViewModel.dispose();
    myPageViewModel.dispose();
  }
}

Future<void> main() async {
  await FirebaseSetter.init();
  MyPageViewModelTest myPageViewModelTest = MyPageViewModelTest();

  group('관심사 설정 테스트', () {
    for (int i = 1; i <= 5; ++i) {
      test('관심사 (0 => $i)개 설정 테스트',
          () => myPageViewModelTest.addInterestSuccessTest(i));
    }
    for (int i = 5; i >= 1; --i) {
      test('관심사 (5 => $i)개 설정 테스트',
          () => myPageViewModelTest.clearInterestTest(i));
    }
  });
}
