import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/token_apis.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/error/http_exception.dart';
import 'package:match_42/logger.dart';

class LoginViewModel extends ChangeNotifier {
  final TokenApis _tokenApis;
  final HttpApis _httpApis;

  User? user;

  LoginViewModel(TokenApis tokenApis, HttpApis httpApis)
      : _tokenApis = tokenApis,
        _httpApis = httpApis {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // submitFCMToken(fcmToken);
      // }).onError((error) async {
      //   Logger().d('FCM 토큰 발급에 실패했습니다.');
    });
  }

  Future<void> login(String url) async {
    updateToken(url);
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    // await submitFCMToken(fcmToken);
    await initUser();
    notifyListeners();
  }

  Future<void> updateToken(String url) async {
    Log.logger.d('updateToken Called');

    String token = Uri.parse(url).queryParameters['token'] ??= '';
    bool isSuccess = await _tokenApis.update(token);

    if (isSuccess) {
      Log.logger.d('updateToken Success');
    } else {
      Log.logger.d('updateToken Failure');
    }
  }

  Future<void> logout({required Function redirect}) async {
    Log.logger.d('logout Called');

    bool isSuccess = await _tokenApis.update('');

    if (isSuccess) {
      Log.logger.d('logout Success');
    } else {
      Log.logger.d('logout Failure');
    }
    redirect();
  }

  Future<void> initUser() async {
    // Response response = await http.get(
    //     Uri.parse("${dotenv.env['ROOT_URL']}/api/v1/user/me"),
    //     headers: {'Authorization': 'Bearer ${_tokenApis.read()}'});
    //
    // Map<String, dynamic> json = jsonDecode(response.body);
    //
    // if (response.statusCode != 200) {
    //   return Future.error(HttpException(
    //       statusCode: response.statusCode, message: json['message']));
    // }
    //
    // print('json: $json');
    user = await _httpApis.getUser();
  }

  void updateUser(User user) {
    this.user = user;
    notifyListeners();
  }

  bool isLoginSuccess(String url) {
    return url.contains('${dotenv.env['ROOT_URL']}/api/v1/login/success?token');
  }
}
