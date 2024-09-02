import 'package:mongo_chat_dart/src/helpers/chat_helper/dm_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/room_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ChatUserHelper {
  final MongoConfig _mongoConfig;

  // Constructor to initialize the mongoConfig
  ChatUserHelper(this._mongoConfig);
  Future<void> createIndex() async =>
      await ChatUserController(mongoConfig: _mongoConfig).createIndex();

  Future<List<ChatUser>> getAllUsers() async {
    return await ChatUserController(mongoConfig: _mongoConfig).getData();
  }

  Future<String> addUser(ChatUser chatUser, ) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .addData(chatUser, docId: chatUser.id);
  }

  Future<ChatUser?> getChatUser(String userId) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .getSingleDocument(userId);
  }

  Future<List<ChatUser>> getUsers(List<String> userIds) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .getDataFromIds(userIds);
  }

  Stream<List<ChatUser>> getUsersStream(List<String> userIds) {
    return ChatUserController(mongoConfig: _mongoConfig)
        .getDataStreamFromIds(userIds);
  }

  Future<void> addDmRoom(DmModel dmModel, String userId) async {
    String id =
        await DmModelController(mongoConfig: _mongoConfig).addData(dmModel,docId: dmModel.id);
    var update = mongo.modify.push('dmRooms', id);
    await ChatUserController(mongoConfig: _mongoConfig)
        .updateData(update, userId);
  }

  Future<List<DmModel>> getDmChats(String userId) async {
    var user = await getChatUser(userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    return await DMModelHelper(_mongoConfig).getDmRooms(user.dmRooms);
  }

  Future<List<RoomModel>> getRoomChats(String userId) async {
    var user = await getChatUser(userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    return await RoomModelHelper(_mongoConfig).getRooms(user.rooms);
  }

  Stream<List<RoomModel>> getRoomChatsStream(String userId) async* {
    var user = await getChatUser(userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    yield* RoomModelHelper(_mongoConfig).getRoomsStream(user.rooms);
  }

  Stream<List<DmModel>> getDmChatsStream(String userId) async* {
    var user = await getChatUser(userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    yield* DMModelHelper(_mongoConfig).getDmRoomsStream(user.dmRooms);
  }
}
