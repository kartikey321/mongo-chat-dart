// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

abstract class DataModel<T> {
  DataModel();

  Map<String, dynamic> toMap() => {};
}

class ChatUser extends DataModel<ChatUser> {
  String id;
  String name;
  String dpUrl;
  String bio;
  String phoneNo;
  String emailId;
  DateTime lastSeen;
  String userName;
  ChatUser({
    required this.id,
    required this.name,
    required this.dpUrl,
    required this.bio,
    required this.phoneNo,
    required this.emailId,
    required this.lastSeen,
    required this.userName,
  });

  ChatUser copyWith({
    String? id,
    String? name,
    String? dpUrl,
    String? bio,
    String? phoneNo,
    String? emailId,
    DateTime? lastSeen,
    String? userName,
  }) {
    return ChatUser(
      id: id ?? this.id,
      name: name ?? this.name,
      dpUrl: dpUrl ?? this.dpUrl,
      bio: bio ?? this.bio,
      phoneNo: phoneNo ?? this.phoneNo,
      emailId: emailId ?? this.emailId,
      lastSeen: lastSeen ?? this.lastSeen,
      userName: userName ?? this.userName,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dpUrl': dpUrl,
      'bio': bio,
      'phoneNo': phoneNo,
      'emailId': emailId,
      'lastSeen': lastSeen.toIso8601String(),
      'userName': userName,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'] as String,
      name: map['name'] as String,
      dpUrl: map['dpUrl'] as String,
      bio: map['bio'] as String,
      phoneNo: map['phoneNo'] as String,
      emailId: map['emailId'] as String,
      lastSeen: DateTime.parse(map['lastSeen'] as String),
      userName: map['userName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name, dpUrl: $dpUrl, bio: $bio, phoneNo: $phoneNo, emailId: $emailId, lastSeen: $lastSeen, userName: $userName)';
  }

  @override
  bool operator ==(covariant ChatUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.dpUrl == dpUrl &&
        other.bio == bio &&
        other.phoneNo == phoneNo &&
        other.emailId == emailId &&
        other.lastSeen == lastSeen &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        dpUrl.hashCode ^
        bio.hashCode ^
        phoneNo.hashCode ^
        emailId.hashCode ^
        lastSeen.hashCode ^
        userName.hashCode;
  }

  @override
  ChatUser fromMap(Map<String, dynamic> map) => ChatUser.fromMap(map);
}
