import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/error/http_exception.dart';

class UserService {
  static UserService instance = UserService._();

  UserService._();

  Future<List<String>> getUserIntraNames(List<int> ids, String token) async {
    Uri uri = Uri.http(
        '${dotenv.env['ROOT_URL']}'.substring(7), '/api/v1/user/intra', {
      'userIdList': ids.map((e) => e.toString()).toList(),
    });

    print(uri);

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: response.body));
    }

    print(response.body);

    return [];
  }

  Future<void> sendNotification(int userId, String msg, String token) async {
    Uri uri = Uri.http('${dotenv.env['ROOT_URL']}'.substring(7),
        '/api/v1/firebase/message/send/$userId', {
      'message': msg,
    });

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: '알림 전송에 실패했습니다'));
    }
  }
}
