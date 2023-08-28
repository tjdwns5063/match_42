import 'package:flutter/material.dart';
import 'package:match_42/data/user.dart';

class LoginViewModel extends ChangeNotifier {
  String token = '';
  late User user;

  void updateToken(String token) {
    token = token;
  }

  void updateUser(User user) {
    this.user = user;

    notifyListeners();
  }
}
