import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:match_42/data/user.dart';

class LoginViewModel extends ChangeNotifier {
  String token = '';
  User? user;

  void updateToken(String url) {
    String token = Uri.parse(url).queryParameters['token'] as String;

    this.token = token;
  }

  Future<void> updateUser() async {
    Response response = await http.get(
        Uri.parse("http://115.85.181.92/api/v1/user/me"),
        headers: {'Authorization': 'Bearer $token'});

    Map<String, dynamic> json = jsonDecode(response.body);
    user = User.fromJson(json);
    print(user);
    notifyListeners();
  }

  bool isLoginSuccess(String url) {
    return url.contains('http://115.85.181.92/api/v1/login/success?token');
  }
}
