import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/error/http_exception.dart';

class LoginViewModel extends ChangeNotifier {
  String _token = '';
  String get token => _token;

  User? user;

  Future<void> login(String url) async {
    updateToken(url);
    await submitFCMToken();
    await initUser();
    notifyListeners();
  }

  void updateToken(String url) {
    String token = Uri.parse(url).queryParameters['token'] as String;

    _token = token;
    print(token);
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

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message']));
    }

    user = User.fromJson(json);
  }

  Future<void> submitFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    Uri uri = Uri.parse(
        'http://115.85.181.92/api/v1/firebase/token/subscribe?token=$fcmToken');

    http.Response response = await http.post(uri, headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: 'FCM 토큰 등록에 실패했습니다.'));
    }
  }

  void updateUser(User user) {
    this.user = user;
    notifyListeners();
  }

  bool isLoginSuccess(String url) {
    return url.contains('${dotenv.env['ROOT_URL']}/api/v1/login/success?token');
  }
}
