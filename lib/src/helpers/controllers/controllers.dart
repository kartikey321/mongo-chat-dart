import 'package:mongo_chat_dart/src/helpers/data_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';
import 'package:mongo_chat_dart/src/models/readby.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_chat_dart/src/utils/collection_names.dart';

class ChatUserController extends GenericDataController<ChatUser> {
  ChatUserController({
    required super.mongoHelper,
  }) : super(fromMap: ChatUser.fromMap, collectionName: CollectionNames.USERS);
}

class MessageController extends GenericDataController<Message> {
  MessageController({
    required super.mongoHelper,
  }) : super(
            fromMap: Message.fromMap, collectionName: CollectionNames.MESSAGES);
}

class MessageReadByController extends GenericDataController<MessageReadBy> {
  MessageReadByController({
    required super.mongoHelper,
  }) : super(
            fromMap: MessageReadBy.fromMap,
            collectionName: CollectionNames.READ_BY);
}

class DmModelController extends GenericDataController<DmModel> {
  DmModelController({
    required super.mongoHelper,
  }) : super(fromMap: DmModel.fromMap, collectionName: CollectionNames.DM_CHAT);
}

class RoomModelController extends GenericDataController<RoomModel> {
  RoomModelController({
    required super.mongoHelper,
  }) : super(
            fromMap: RoomModel.fromMap,
            collectionName: CollectionNames.ROOM_CHAT);
}
