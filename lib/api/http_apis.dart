import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match_42/api/interceptor.dart';
import 'package:match_42/error/http_exception.dart';
import 'package:dio/dio.dart';

import '../data/user.dart';
import 'firebase/match_api.dart';

const String _ROOT_URL_ID = 'ROOT_URL';

class HttpApis {
  static HttpApis? _instance;

  Dio _dio;

  HttpApis._(this._dio) {
    _dio.interceptors.add(CustomInterceptor());
  }

  factory HttpApis.instance(String token) {
    BaseOptions options = BaseOptions(
      baseUrl: dotenv.env[_ROOT_URL_ID] as String,
      headers: {
        'Authorization': 'Bearer $token',
      },
      contentType: 'application/json',
    );

    _instance ??= HttpApis._(Dio(options));

    return _instance as HttpApis;
  }

  Future<void> _sendNotification(Map<String, dynamic> body, String type) async {
    Response<void> response = await _dio.post(
      '/api/v1/firebase/message/send/$type',
      data: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode!, message: '알림 전송에 실패했습니다'));
    }
  }

  Future<void> sendChatNotification(Map<String, dynamic> body) async {
    _sendNotification(body, 'chat');
  }

  Future<void> sendCreateChatNotification(MatchData matchData) async {
    _sendNotification(matchData.toJson(), 'create_chat');
  }

  Future<void> sendMatchNotification(Map<String, dynamic> body) async {
    _sendNotification(body, 'match');
  }

  Future<void> sendReport(int userId, List<String> reasons) async {
    await _dio.post('/api/v1/user/report',
        data: jsonEncode({
          'reportedId': userId,
          'reasons': reasons,
        }));
  }

  Future<User> addBlockUser(String intraId) async {
    Response response = await _dio.post('/api/v1/user/block', queryParameters: {
      'blockUser': intraId,
    });

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode!, message: response.data));
    }
    Map<String, dynamic> json = jsonDecode(response.data);

    return User.fromJson(json);
  }

  Future<User> deleteBlockUser(String intraId) async {
    Response response =
        await _dio.delete('/api/v1/user/block', queryParameters: {
      'blockUser': intraId,
    });

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode!, message: response.data));
    }
    Map<String, dynamic> json = jsonDecode(response.data);

    return User.fromJson(json);
  }

  Future<List<String>> getInterestsById(int userId) async {
    Response response = await _dio.get('/api/v1/user/interest/$userId');

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode ??= 500, message: response.data));
    }
    Map<String, dynamic> json = jsonDecode(response.data);

    return List<String>.from(json['interests'].toList());
  }

  Future<User> postInterests(List<String> interests) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/user/interest');

    Response response = await _dio.put(
      '/api/v1/user/interest',
      // headers: {
      //   'Content-Type': 'application/json',
      //   'content-encoding': 'utf-8',
      //   'Authorization': 'Bearer $token',
      // },
      data: jsonEncode(interests),
    );

    // print(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode ??= 500, message: response.data));
    }

    return User.fromJson(response.data);
  }
}
