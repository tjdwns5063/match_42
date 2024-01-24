import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/error/http_exception.dart';
import 'package:match_42/service/match_service.dart';

class UserService {
  static UserService instance = UserService._();

  UserService._();

  Future<void> sendChatNotification(
      Map<String, dynamic> body, String msg, String token) async {
    Uri uri = Uri.http('${dotenv.env['ROOT_URL']}'.substring(7),
        '/api/v1/firebase/message/send/chat', {
      'message': msg,
    });

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: '알림 전송에 실패했습니다'));
    }
  }

  Future<void> sendCreateChatNotification(
      MatchData matchData, String token) async {
    print('send Create Chat');
    Uri uri = Uri.http('${dotenv.env['ROOT_URL']}'.substring(7),
        '/api/v1/firebase/message/send/create_chat');

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(matchData.toJson()));

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: '알림 전송에 실패했습니다'));
    }
  }

  Future<void> sendMatchNotification(
      Map<String, dynamic> body, String token) async {
    Uri uri = Uri.http('${dotenv.env['ROOT_URL']}'.substring(7),
        '/api/v1/firebase/message/send/match');

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: '알림 전송에 실패했습니다'));
    }
  }
}
