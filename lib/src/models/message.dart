// This file is part of the mongo_chat_dart package.
//
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/message_document.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Message extends DataModel {
  String text;
  String id;
  DateTime sentAt;
  Message({
    required this.text,
    required this.sentAt,
  }) : id = ObjectId().oid;
  Message._internal({required this.text, required this.sentAt, String? id})
      : id = id ?? ObjectId().oid;
  @override
  Map<String, dynamic> toMap() {
    return this is SystemMessage
        ? ((this as SystemMessage).toMap())
        : (this as ChatMessage).toMap();
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return map['sentBy'] != null
        ? ChatMessage.fromMap(map)
        : SystemMessage.fromMap(map);
  }
  static Map<String, bool> createIndex() => {"id": true};
}

class SystemMessage extends Message {
  SystemMessage({required super.text, required super.sentAt});
  SystemMessage._internal(
      {required super.text, required super.sentAt, super.id})
      : super._internal();
  @override
  Map<String, dynamic> toMap() {
    return {"id": id, "text": text, "sentAt": sentAt};
  }

  factory SystemMessage.fromMap(Map<String, dynamic> map) {
    return SystemMessage._internal(
        text: map["text"] as String,
        sentAt: DateTime.parse(map['sentAt'] as String),
        id: map['id'] != null ? map['id'] as String : null);
  }
}

class ChatMessage extends Message {
  MessageDocument? document;
  String? replyToMessageId;
  String sentBy;
  ChatMessage({
    required super.text,
    required super.sentAt,
    this.replyToMessageId,
    required this.sentBy,
  });
  ChatMessage._internal({
    required super.text,
    required super.sentAt,
    super.id,
    this.replyToMessageId,
    required this.sentBy,
  }) : super._internal();

  ChatMessage copyWith({
    String? text,
    String? id,
    DateTime? sentAt,
    String? replyToMessageId,
    String? sentBy,
  }) {
    return ChatMessage._internal(
      text: text ?? this.text,
      id: id ?? this.id,
      sentAt: sentAt ?? this.sentAt,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      sentBy: sentBy ?? this.sentBy,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'id': id,
      'sentAt': sentAt.toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'sentBy': sentBy,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage._internal(
      text: map['text'] as String,
      id: map['id'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
      replyToMessageId: map['replyToMessageId'] != null
          ? map['replyToMessageId'] as String
          : null,
      sentBy: map['sentBy'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(text: $text, id: $id, sentAt: $sentAt, replyToMessageId: $replyToMessageId, sentBy: $sentBy)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.id == id &&
        other.sentAt == sentAt &&
        other.replyToMessageId == replyToMessageId &&
        other.sentBy == sentBy;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        id.hashCode ^
        sentAt.hashCode ^
        replyToMessageId.hashCode ^
        sentBy.hashCode;
  }
}
