import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:match_42/error/http_exception.dart';

class MatchData {
  MatchData(
      {required this.id,
      required this.size,
      required this.capacity,
      required this.matchType,
      required this.matchStatus,
      required this.firebaseMatchId});

  int id;
  int size;
  int capacity;
  String matchType;
  String matchStatus;
  String firebaseMatchId;

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      id: json['id'],
      size: json['size'],
      capacity: json['capacity'],
      matchType: json['matchType'],
      matchStatus: json['matchStatus'],
      firebaseMatchId: json['firebaseMatchId'],
    );
  }

  factory MatchData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final Map<String, dynamic> data = snapshot.data()!;
    return MatchData(
      id: data['id'],
      size: data['size'],
      capacity: data['capacity'],
      matchType: data['matchType'],
      matchStatus: data['matchStatus'],
      firebaseMatchId: snapshot.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'capacity': capacity,
      'matchType': matchType,
      'matchStatus': matchStatus,
      'firebaseMatchId': firebaseMatchId
    };
  }

  @override
  String toString() {
    return 'id: $id size: $size capacity: $capacity matchType: $matchType matchStatus: $matchStatus firebaseId: $firebaseMatchId';
  }
}

const String _matchCollectionPath = 'match';

class MatchService {
  MatchService._();

  static final MatchService instance = MatchService._();

  final CollectionReference<MatchData> matchRef = FirebaseFirestore.instance
      .collection(_matchCollectionPath)
      .withConverter(
          fromFirestore: MatchData.fromFirestore,
          toFirestore: (MatchData data, options) => data.toJson());

  Future<MatchData> startTalkMatch(int capacity, String token) async {
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

    Map<String, dynamic> json = jsonDecode(response.body);

    return MatchData.fromJson(json);
  }

  Future<void> stopTalkMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/chat/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    // print(response.statusCode);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<MatchData> startSubjectMatch(
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

    // print(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    return MatchData.fromJson(json);
  }

  Future<void> stopSubjectMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/subject/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    // print(response.statusCode);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }
  }

  Future<MatchData> startEatMatch(
      int capacity, String menu, String token) async {
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

    // print(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode,
          message: jsonDecode(response.body)['message']));
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    return MatchData.fromJson(json);
  }

  Future<void> stopEatMatch(String token) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/meal/stop');

    http.Response response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    // print(response.statusCode);

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

    // print(response.body);

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message']));
    }

    return json;
  }

  Future<MatchData> getMatchDataById(
    int id,
    String token,
  ) async {
    Uri uri = Uri.parse('${dotenv.env['ROOT_URL']}/api/v1/match/room/$id');

    http.Response response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    // print('code: ${response.statusCode}');

    print('body: ${response.body}');

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(
          statusCode: response.statusCode, message: json['message']));
    }
    return MatchData.fromJson(json);
  }
}
