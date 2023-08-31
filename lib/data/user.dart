import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/ui/my_page.dart';

class User {
  User({
    required this.id,
    this.nickname = '',
    required this.intra,
    required this.profile,
    interests,
    blockUsers,
  })  : interests = interests ?? <String>[],
        blockUsers = blockUsers ?? <String>[];

  final int id;
  String nickname;
  final String intra;
  final String profile;
  List<String> interests;
  List<String> blockUsers;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'] ?? '',
      intra: json['intra'],
      profile: json['profile'] ?? '',
      interests: json['interests'] == null
          ? <String>[]
          : List<String>.from(json['interests']),
      blockUsers: json['blockUsers'] == null
          ? <String>[]
          : List<String>.from(json['blockUsers']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nickname': nickname,
      'intra': intra,
      'profile': profile,
    };
  }

  @override
  String toString() {
    return 'id: $id nickname: $nickname intra: $intra profile: $profile interests: $interests, blockUsers: $blockUsers';
  }
}
