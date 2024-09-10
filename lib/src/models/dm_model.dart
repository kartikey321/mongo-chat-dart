// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DmModel extends DataModel {
  String id;
  String participant1Id;
  String participant2Id;
  DateTime createdOn;
  List<String> messageIds;
  DmModel({
    required this.participant1Id,
    required this.participant2Id,
    required this.createdOn,
  })  : id = ObjectId().oid,
        messageIds = [];
  DmModel._internal({
    String? id,
    required this.participant1Id,
    required this.participant2Id,
    required this.createdOn,
    required this.messageIds,
  }) : id = id ?? ObjectId().oid;

  DmModel copyWith({
    String? id,
    String? participant1Id,
    String? participant2Id,
    DateTime? createdOn,
    List<String>? messageIds,
  }) {
    return DmModel._internal(
      id: id ?? this.id,
      participant1Id: participant1Id ?? this.participant1Id,
      participant2Id: participant2Id ?? this.participant2Id,
      createdOn: createdOn ?? this.createdOn,
      messageIds: messageIds ?? this.messageIds,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participant1Id': participant1Id,
      'participant2Id': participant2Id,
      'createdOn': createdOn.toIso8601String(),
      'messageIds': messageIds,
    };
  }

  factory DmModel.fromMap(Map<String, dynamic> map) {
    return DmModel._internal(
      id: map['id'] as String,
      participant1Id: map['participant1Id'] as String,
      participant2Id: map['participant2Id'] as String,
      createdOn: DateTime.parse(map['createdOn'] as String),
      messageIds: List<String>.from(
        (map['messageIds'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DmModel.fromJson(String source) =>
      DmModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DmModel(id: $id, participant1Id: $participant1Id, participant2Id: $participant2Id, createdOn: $createdOn, messageIds: $messageIds)';
  }

  @override
  bool operator ==(covariant DmModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.participant1Id == participant1Id &&
        other.participant2Id == participant2Id &&
        other.createdOn == createdOn &&
        listEquals(other.messageIds, messageIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        participant1Id.hashCode ^
        participant2Id.hashCode ^
        createdOn.hashCode ^
        messageIds.hashCode;
  }

  static Map<String, bool> createIndex() => {"id": true};
}
