// TODO: Put public facing types in this file.

import 'package:mongo_chat_dart/src/helpers/chat_helper/chat_user_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/dm_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/message_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/read_by_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/room_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';

class MongoChatDart {
  MongoConfig? _mongoConfig;

  // Initialize function to set up MongoDB connection and helpers
  Future<void> initialize(String mongoUrl) async {
    _mongoConfig = MongoConfig(mongoUrl);
    await _mongoConfig!.initialize();

    // Initialize helpers after MongoConfig is set up
    _chatUser = ChatUserHelper(_mongoConfig!);
    _dmModel = DMModelHelper(_mongoConfig!);
    _message = MessageHelper(_mongoConfig!);
    _readBy = MessageReadByHelper(_mongoConfig!);
    _roomModel = RoomModelHelper(_mongoConfig!);

    await _chatUser.createIndex();
    await _dmModel.createIndex();
    await _message.createIndex();
    await _readBy.createIndex();
    await _roomModel.createIndex();
  }

  // Helper instance variables
  late ChatUserHelper _chatUser;
  late DMModelHelper _dmModel;
  late MessageHelper _message;
  late MessageReadByHelper _readBy;
  late RoomModelHelper _roomModel;

  // Getters for helpers with null checks for mongoConfig
  ChatUserHelper get chatUser {
    if (_mongoConfig == null) {
      throw Exception(
          'MongoConfig is not initialized. Call initialize() first.');
    }
    return _chatUser;
  }

  DMModelHelper get dmModel {
    if (_mongoConfig == null) {
      throw Exception(
          'MongoConfig is not initialized. Call initialize() first.');
    }
    return _dmModel;
  }

  MessageHelper get message {
    if (_mongoConfig == null) {
      throw Exception(
          'MongoConfig is not initialized. Call initialize() first.');
    }
    return _message;
  }

  MessageReadByHelper get readBy {
    if (_mongoConfig == null) {
      throw Exception(
          'MongoConfig is not initialized. Call initialize() first.');
    }
    return _readBy;
  }

  RoomModelHelper get roomModel {
    if (_mongoConfig == null) {
      throw Exception(
          'MongoConfig is not initialized. Call initialize() first.');
    }
    return _roomModel;
  }
}
