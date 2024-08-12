import 'package:mongo_chat_dart/src/helpers/chat_helper/dm_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/room_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ChatUserHelper {
  static Future<List<ChatUser>> getAllUsers(MongoHelper mongoHelper) async =>
      await ChatUserController(mongoHelper: mongoHelper).getData();
  static Future<void> addUser(
          MongoHelper mongoHelper, ChatUser chatUser) async =>
      await ChatUserController(mongoHelper: mongoHelper).addData(chatUser);
  static Future<ChatUser?> getChatUser(
          MongoHelper mongoHelper, String userId) async =>
      await ChatUserController(mongoHelper: mongoHelper)
          .getSingleDocument(userId);
  static Future<List<ChatUser>> getUsers(
          MongoHelper mongoHelper, List<String> userIds) async =>
      await ChatUserController(mongoHelper: mongoHelper)
          .getDataFromIds(userIds);
  static Stream<List<ChatUser>> getUsersStream(
          MongoHelper mongoHelper, List<String> userIds) =>
      ChatUserController(mongoHelper: mongoHelper)
          .getDataStreamFromIds(userIds);
  static Future<void> addDmRoom(
      MongoHelper mongoHelper, DmModel dmModel, String userId) async {
    String id =
        await DmModelController(mongoHelper: mongoHelper).addData(dmModel);
    var update = mongo.modify.push('dmRooms', id);
    await ChatUserController(mongoHelper: mongoHelper)
        .updateData(update, userId);
  }

  static Future<List<DmModel>> getDmChats(
      MongoHelper mongoHelper, String userId) async {
    var user = await getChatUser(mongoHelper, userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    return await DMModelHelper.getDmRooms(mongoHelper, user.dmRooms);
  }

  static Future<List<RoomModel>> getRoomChats(
      MongoHelper mongoHelper, String userId) async {
    var user = await getChatUser(mongoHelper, userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    return await RoomModelHelper.getRooms(user.rooms, mongoHelper);
  }

  static Stream<List<RoomModel>> getRoomChatsStream(
      MongoHelper mongoHelper, String userId) async* {
    var user = await getChatUser(mongoHelper, userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    yield* await RoomModelHelper.getRoomsStream(user.rooms, mongoHelper);
  }

  static Stream<List<DmModel>> getDmChatsStream(
      MongoHelper mongoHelper, String userId) async* {
    var user = await getChatUser(mongoHelper, userId);
    if (user == null) {
      throw Exception('This User does not exist');
    }
    yield* DMModelHelper.getDmRoomsStream(mongoHelper, user.dmRooms);
  }
}
