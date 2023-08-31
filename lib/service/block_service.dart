import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/data/user.dart';
import 'package:match_42/error/error_util.dart';
import 'package:match_42/error/http_exception.dart';

class BlockService {
  static BlockService instance = BlockService._create();
  String rootUrl = dotenv.env['ROOT_URL']!;

  BlockService._create();

  Future<User> addBlockUser(String intraId, String token) async {
    Uri uri = Uri.http(rootUrl.substring(7), '/api/v1/user/block', {
      'blockUser': intraId,
    });

    print(uri);

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message'] ?? ''));
    }

    return User.fromJson(json);
  }

  Future<User> deleteBlockUser(String intraId, String token) async {
    Uri uri = Uri.http(rootUrl.substring(7), '/api/v1/user/block', {
      'blockUser': intraId,
    });

    http.Response response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message'] ?? ''));
    }

    return User.fromJson(json);
  }
}
