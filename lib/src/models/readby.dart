// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_chat_dart/src/models/chat_user.dart';

class ReadBy extends DataModel<ReadBy> {
  String userId;
  DateTime timeStamp;
  ReadBy({
    required this.userId,
    required this.timeStamp,
  });

  ReadBy copyWith({
    String? userId,
    DateTime? timeStamp,
  }) {
    return ReadBy(
      userId: userId ?? this.userId,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  factory ReadBy.fromMap(Map<String, dynamic> map) {
    return ReadBy(
      userId: map['userId'] as String,
      timeStamp: DateTime.parse(map['timeStamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadBy.fromJson(String source) =>
      ReadBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReadBy(userId: $userId, timeStamp: $timeStamp)';

  @override
  bool operator ==(covariant ReadBy other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => userId.hashCode ^ timeStamp.hashCode;
}