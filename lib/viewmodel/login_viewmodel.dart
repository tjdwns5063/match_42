import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match_42/api/http_apis.dart';
import 'package:match_42/api/token_apis.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/logger.dart';

class LoginViewModel extends ChangeNotifier {
  final TokenApis _tokenApis;
  final HttpApis _httpApis;

  User? user;

  LoginViewModel(TokenApis tokenApis, HttpApis httpApis)
      : _tokenApis = tokenApis,
        _httpApis = httpApis {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      _httpApis.submitFCMToken(fcmToken);
    }).onError((error) async {
      Log.logger.d('FCM 토큰 발급에 실패했습니다.');
    });
  }

  Future<void> login(String url) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    updateToken(url);
    await _httpApis.submitFCMToken(fcmToken);
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
