// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/readby.dart';

class MessageReadBy extends DataModel {
  String messageId;
  List<ReadBy> readByList;
  MessageReadBy({
    required this.messageId,
    required this.readByList,
  });

  MessageReadBy copyWith({
    String? messageId,
    List<ReadBy>? readByList,
  }) {
    return MessageReadBy(
      messageId: messageId ?? this.messageId,
      readByList: readByList ?? this.readByList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'readByList': readByList.map((x) => x.toMap()).toList(),
    };
  }

  factory MessageReadBy.fromMap(Map<String, dynamic> map) {
    return MessageReadBy(
      messageId: map['messageId'] as String,
      readByList: List<ReadBy>.from(
        (map['readByList'] as List).map<ReadBy>(
          (x) => ReadBy.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageReadBy.fromJson(String source) =>
      MessageReadBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MessageReadBy(messageId: $messageId, readByList: $readByList)';

  @override
  bool operator ==(covariant MessageReadBy other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.messageId == messageId &&
        listEquals(other.readByList, readByList);
  }

  @override
  int get hashCode => messageId.hashCode ^ readByList.hashCode;

  static Map<String, bool> createIndex() => {"messageId": true};
}
