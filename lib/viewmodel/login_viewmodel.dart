import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String token = '';
  // late User user;

  void updateToken(String token) {
    token = token;

    notifyListeners();
  }
}
