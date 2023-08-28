import 'package:flutter/cupertino.dart';
import 'package:match_42/ui/my_page.dart';
import 'package:match_42/data/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class MyPageViewModel extends ChangeNotifier {
  User user;
  String token;
  late List<Interest> interestList;

  MyPageViewModel({required this.user, required this.token}) {
    var lst = user.interests;
    interestList = <Interest>[];

    for (String? interest in lst) {
      if (interest != null) {
        interestList.add(Interest(interest, true));
      }
    }
  }

  bool checkInterest(String interest, List<String?> interestList) {
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i] == interest) return true;
    }
    return false;
  }

  List<String> allInterest = [
    // '운동',
    // '코딩',
    // '반려동물',
    'abc',
    'def',
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

  late List<Interest> isSelect = [
    for (int i = 0; i < allInterest.length; i++)
      Interest(allInterest[i], checkInterest(allInterest[i], user.interests))
  ];

  void onPressed(int index) {
    isSelect[index].isSelect = !isSelect[index].isSelect;

    notifyListeners();
  }

  verifyButton(BuildContext context) async {
    LoginViewModel loginViewModel = context.read();
    for (int i = 0; i < isSelect.length; i++) {
      if (isSelect[i].isSelect) {
        Uri uri = Uri.http('115.85.181.92', '/api/v1/user/interest',
            {'interest': isSelect[i].title});
        print(isSelect[i].title);

        print(uri.toString());

        Response response =
            await http.post(uri, headers: {'Authorization': 'Bearer $token'});
        print('body: ${response.body} ${response.headers}');
        // Map<String, dynamic> json = jsonDecode(response.body);
        // User user = User.fromJson(json);
        // loginViewModel.updateUser(user);
      }
    }
  }
}
