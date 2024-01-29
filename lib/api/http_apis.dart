import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match_42/api/interceptor.dart';
import 'package:match_42/error/http_exception.dart';
import 'package:dio/dio.dart';

import '../service/match_service.dart';

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
    Response<String> response = await _dio.post('/api/v1/user/report',
        data: jsonEncode({
          'reportedId': userId,
          'reasons': reasons,
        }));
  }
}
