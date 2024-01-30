class BlockUser {
  final int id;
  final String intra;

  BlockUser({required this.id, required this.intra});

  factory BlockUser.fromJson(Map<String, dynamic> json) {
    return BlockUser(id: json['id'], intra: json['intra']);
  }

  Map<String, dynamic> toFirestore() {
    return {'id': id, 'intra': intra};
  }

  @override
  String toString() {
    return 'id: $id intra: $intra';
  }
}

class BlockInfo {
  final BlockUser to;
  final BlockUser from;

  BlockInfo({required this.to, required this.from});

  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    return BlockInfo(
        to: BlockUser.fromJson(json['to']),
        from: BlockUser.fromJson(json['from']));
  }

  Map<String, dynamic> toFirestore() {
    return {'to': to.toFirestore(), 'from': from.toFirestore()};
  }

  @override
  String toString() {
    return 'to: $to from: $from';
  }
}
