// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class RoomModelConfig {
  bool allCanMessage;
  RoomModelConfig({
    required this.allCanMessage,
  });

  RoomModelConfig copyWith({
    bool? allCanMessage,
  }) {
    return RoomModelConfig(
      allCanMessage: allCanMessage ?? this.allCanMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allCanMessage': allCanMessage,
    };
  }

  factory RoomModelConfig.fromMap(Map<String, dynamic> map) {
    return RoomModelConfig(
      allCanMessage: map['allCanMessage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModelConfig.fromJson(String source) =>
      RoomModelConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RoomModelConfig(allCanMessage: $allCanMessage)';

  @override
  bool operator ==(covariant RoomModelConfig other) {
    if (identical(this, other)) return true;

    return other.allCanMessage == allCanMessage;
  }

  @override
  int get hashCode => allCanMessage.hashCode;
}

class RoomModel extends DataModel {
  String id;
  String name;
  String createdBy;
  String createdAt;
  List<String> admins;
  String description;
  List<String> allParticipants;
  List<String> messageIds;
  RoomModel({
    String? id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.admins,
    required this.description,
    required this.allParticipants,
    required this.messageIds,
  }):id = id ?? ObjectId().oid;

  RoomModel copyWith({
    String? id,
    String? name,
    String? createdBy,
    String? createdAt,
    List<String>? admins,
    String? description,
    List<String>? allParticipants,
    List<String>? messageIds,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      admins: admins ?? this.admins,
      description: description ?? this.description,
      allParticipants: allParticipants ?? this.allParticipants,
      messageIds: messageIds ?? this.messageIds,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'admins': admins,
      'description': description,
      'allParticipants': allParticipants,
      'messageIds': messageIds,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] as String,
      admins: List<String>.from(
        (map['admins'] as List),
      ),
      description: map['description'] as String,
      allParticipants: List<String>.from(
        (map['allParticipants'] as List),
      ),
      messageIds: List<String>.from(
        (map['messageIds'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomModel(id: $id, name: $name, createdBy: $createdBy, createdAt: $createdAt, admins: $admins, description: $description, allParticipants: $allParticipants, messageIds: $messageIds)';
  }

  @override
  bool operator ==(covariant RoomModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        listEquals(other.admins, admins) &&
        other.description == description &&
        listEquals(other.allParticipants, allParticipants) &&
        listEquals(other.messageIds, messageIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        admins.hashCode ^
        description.hashCode ^
        allParticipants.hashCode ^
        messageIds.hashCode;
  }

  
 static  Map<String, bool> createIndex() => {"id": true};
}
