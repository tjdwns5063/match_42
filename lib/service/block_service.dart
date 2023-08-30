import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/data/user.dart';

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

    if (response.statusCode != 200) {
      return Future.error(Exception(response.statusCode));
    }

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> deleteBlockUser(String intraId, String token) async {
    Uri uri = Uri.http(rootUrl.substring(7), '/api/v1/user/block', {
      'blockUser': intraId,
    });

    http.Response response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      return Future.error(Exception(response.statusCode));
    }

    return User.fromJson(jsonDecode(response.body));
  }
}
