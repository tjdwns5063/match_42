import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:match_42/data/user.dart';

class LoginViewModel extends ChangeNotifier {
  String _token = '';
  String get token => _token;

  User? user;

  void updateToken(String url) {
    String token = Uri.parse(url).queryParameters['token'] as String;

    _token = token;
  }

  void logout({required Function redirect}) {
    _token = '';
    redirect();
  }

  Future<void> initUser() async {
    Response response = await http.get(
        Uri.parse("${dotenv.env['ROOT_URL']}/api/v1/user/me"),
        headers: {'Authorization': 'Bearer $token'});

    Map<String, dynamic> json = jsonDecode(response.body);
    user = User.fromJson(json);
    notifyListeners();
  }

  void updateUser(User user) {
    this.user = user;
    notifyListeners();
  }

  bool isLoginSuccess(String url) {
    return url.contains('${dotenv.env['ROOT_URL']}/api/v1/login/success?token');
  }
}
