import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/error/http_exception.dart';

class MatchService {
  const MatchService._();

  static const MatchService instance = MatchService._();

  Future<void> startTalkMatch(int capacity, String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/chat/start');

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'capacity': capacity,
        }));

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<void> stopTalkMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/chat/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<void> startSubjectMatch(
      int capacity, String project, String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/subject/start');

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'capacity': capacity,
          'project': project,
        }));

    print(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<void> stopSubjectMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/subject/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<void> startEatMatch(int capacity, String menu, String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/meal/start');

    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'capacity': capacity,
          'menu': menu,
        }));

    print(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<void> stopEatMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/meal/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<Map<String, dynamic>> getMatchData(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/me');

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.body);

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message']));
    }
    return json;
  }
}
