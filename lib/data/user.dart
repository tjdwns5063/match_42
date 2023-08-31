import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/data/chat_room.dart';
import 'package:match_42/ui/my_page.dart';

class User {
  User({
    required this.id,
    this.nickname = '',
    required this.intra,
    this.profile = '',
    interests,
    blockUsers,
  })  : interests = interests ?? <String>[],
        blockUsers = blockUsers ?? <String>[];

  final int id;
  String nickname;
  final String intra;
  String profile;
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

  void decideNickname(ChatRoom room) {
    nickname = switch (room.users.indexOf(id)) {
      0 => '건',
      1 => '곤',
      2 => '감',
      3 => '리',
      _ => '리',
    };
  }

  void decideProfile(ChatRoom room) {
    profile = switch (room.users.indexOf(id)) {
      0 => 'gun.png',
      1 => 'gon.png',
      2 => 'gam.png',
      3 => 'lee.png',
      _ => 'lee.png',
    };
  }

  @override
  String toString() {
    return 'id: $id nickname: $nickname intra: $intra profile: $profile interests: $interests, blockUsers: $blockUsers';
  }
}
