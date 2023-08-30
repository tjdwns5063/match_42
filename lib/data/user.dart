import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_42/ui/my_page.dart';

class User {
  User({
    required this.id,
    this.nickname = '',
    required this.intra,
    required this.profile,
    interests,
  }) : interests = interests ?? [];

  final int id;
  String nickname;
  final String intra;
  final String profile;
  List<String?> interests;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      id: data!['id'],
      nickname: data['nickname'],
      intra: data['intra'],
      profile: data['profile'],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'] ?? '',
      intra: json['intra'],
      profile: json['profile'] ?? '',
      interests: json['interests'] == null
          ? <String>[]
          : List<String>.from(json['interests']),
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
    return 'id: $id nickname: $nickname intra: $intra profile: $profile interests: $interests';
  }
}
