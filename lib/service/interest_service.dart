import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/data/user.dart';

class InterestService {
  static final instance = InterestService._create();

  InterestService._create();

  Future<List<String>> getInterestsById(int userId, String token) async {
    Uri uri =
        Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/user/interest/$userId');

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      return Future.error(Exception('http error'));
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    return List<String>.from(json['interests'].toList());
  }

  Future<User> postInterests(List<String> interests, String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/user/interest');

    http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'content-encoding': 'utf-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(interests),
    );

    print(response.body);

    if (response.statusCode != 200) {
      return Future.error(Exception('http error'));
    }

    return User.fromJson(jsonDecode(response.body));
  }
}
