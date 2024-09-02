// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/message_document.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Message extends DataModel {
  String text;
  String id;
  DateTime sentAt;
  MessageDocument? document;
  String? replyToMessageId;
  ChatUser sentBy;
  Message({
    required this.text,
   
    required this.sentAt,
    this.replyToMessageId,
    required this.sentBy,
  }):id =  ObjectId().oid;
  Message._internal({
    required this.text,
    String? id,
    required this.sentAt,
    this.replyToMessageId,
    required this.sentBy,
  }):id = id ?? ObjectId().oid;

  Message copyWith({
    String? text,
    String? id,
    DateTime? sentAt,
    String? replyToMessageId,
    ChatUser? sentBy,
  }) {
    return Message._internal(
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
      'sentBy': sentBy.toMap(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message._internal(
      text: map['text'] as String,
      id: map['id'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
      replyToMessageId: map['replyToMessageId'] != null
          ? map['replyToMessageId'] as String
          : null,
      sentBy: ChatUser.fromMap(map['sentBy'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(text: $text, id: $id, sentAt: $sentAt, replyToMessageId: $replyToMessageId, sentBy: $sentBy)';
  }

  @override
  bool operator ==(covariant Message other) {
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

  
  static Map<String, bool> createIndex() => {"id": true};
}
