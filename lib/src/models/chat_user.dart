// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:mongo_dart/mongo_dart.dart';

abstract class DataModel {
  Map<String, dynamic> toMap();
  static Map<String, bool> createIndex() => {};
}

class ChatUser extends DataModel {
  String id;
  String name;
  String? dpUrl;
  String? bio;
  String? phoneNo;
  String? emailId;
  DateTime? lastSeen;
  String? userName;
  List<String> dmRooms;
  List<String> rooms;
  ChatUser({
    required this.name,
    this.dpUrl,
    this.bio,
    this.phoneNo,
    this.emailId,
    this.lastSeen,
    this.userName,
    List<String>? dmRooms,
    List<String>? rooms,
  })  : id = ObjectId().oid,
        dmRooms = dmRooms ?? [],
        rooms = rooms ?? [];
  ChatUser._internal({
    String? id,
    required this.name,
    this.dpUrl,
    this.bio,
    this.phoneNo,
    this.emailId,
    this.lastSeen,
    this.userName,
    required this.dmRooms,
    required this.rooms,
  }) : id = id ?? ObjectId().oid;

  ChatUser copyWith({
    String? name,
    String? dpUrl,
    String? bio,
    String? phoneNo,
    String? emailId,
    DateTime? lastSeen,
    String? userName,
    List<String>? dmRooms,
    List<String>? rooms,
  }) {
    return ChatUser(
      name: name ?? this.name,
      dpUrl: dpUrl ?? this.dpUrl,
      bio: bio ?? this.bio,
      phoneNo: phoneNo ?? this.phoneNo,
      emailId: emailId ?? this.emailId,
      lastSeen: lastSeen ?? this.lastSeen,
      userName: userName ?? this.userName,
      dmRooms: dmRooms ?? this.dmRooms,
      rooms: rooms ?? this.rooms,
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
      'lastSeen': lastSeen?.toIso8601String(),
      'userName': userName,
      'dmRooms': dmRooms,
      'rooms': rooms,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser._internal(
      id: map['id'] as String,
      name: map['name'] as String,
      dpUrl: map['dpUrl'] != null ? map['dpUrl'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      emailId: map['emailId'] != null ? map['emailId'] as String : null,
      lastSeen: map['lastSeen'] != null
          ? DateTime.parse(map['lastSeen'] as String)
          : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      dmRooms: List<String>.from(
        (map['dmRooms'] as List),
      ),
      rooms: List<String>.from(
        (map['rooms'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name, dpUrl: $dpUrl, bio: $bio, phoneNo: $phoneNo, emailId: $emailId, lastSeen: $lastSeen, userName: $userName, dmRooms: $dmRooms, rooms: $rooms)';
  }

  @override
  bool operator ==(covariant ChatUser other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.dpUrl == dpUrl &&
        other.bio == bio &&
        other.phoneNo == phoneNo &&
        other.emailId == emailId &&
        other.lastSeen == lastSeen &&
        other.userName == userName &&
        listEquals(other.dmRooms, dmRooms) &&
        listEquals(other.rooms, rooms);
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
        userName.hashCode ^
        dmRooms.hashCode ^
        rooms.hashCode;
  }

  static Map<String, bool> createIndex() => {"id": true, "name": true};
}
