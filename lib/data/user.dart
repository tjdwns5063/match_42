import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.nickname,
    required this.intra,
    required this.profile,
  });

  final String nickname;
  final String intra;
  final String profile;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      nickname: data!['nickname'],
      intra: data['intra'],
      profile: data['profile'],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'],
      intra: json['intra'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'intra': intra,
      'profile': profile,
    };
  }

  @override
  String toString() {
    return 'nickname: $nickname intra: $intra profile: $profile';
  }
}
