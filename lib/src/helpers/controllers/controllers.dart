// This file is part of the mongo_chat_dart package.
//
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/src/helpers/data_helper.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_chat_dart/src/utils/collection_names.dart';

class ChatUserController extends GenericDataController<ChatUser> {
  ChatUserController({
    required super.mongoConfig,
  }) : super(
            fromMap: ChatUser.fromMap,
            collectionName: CollectionNames.users,
            index: ChatUser.createIndex());
}

class MessageController extends GenericDataController<Message> {
  MessageController({
    required super.mongoConfig,
  }) : super(
            fromMap: Message.fromMap,
            collectionName: CollectionNames.messages,
            index: Message.createIndex());
}

class MessageReadByController extends GenericDataController<MessageReadBy> {
  MessageReadByController({
    required super.mongoConfig,
  }) : super(
            fromMap: MessageReadBy.fromMap,
            collectionName: CollectionNames.readBy,
            index: MessageReadBy.createIndex());
}

class DmModelController extends GenericDataController<DmModel> {
  DmModelController({
    required super.mongoConfig,
  }) : super(
            fromMap: DmModel.fromMap,
            collectionName: CollectionNames.dmChat,
            index: DmModel.createIndex());
}

class RoomModelController extends GenericDataController<RoomModel> {
  RoomModelController({
    required super.mongoConfig,
  }) : super(
            fromMap: RoomModel.fromMap,
            collectionName: CollectionNames.roomChat,
            index: RoomModel.createIndex());
}
