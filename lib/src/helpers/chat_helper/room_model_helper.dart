import 'package:mongo_chat_dart/src/helpers/chat_helper/message_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RoomModelHelper {
  static Future<String> createRoom(
          MongoHelper mongoHelper, RoomModel roomModel) async =>
      await RoomModelController(mongoHelper: mongoHelper).addData(roomModel);
  Future<void> addParticipants(
      List<ChatUser> users, String roomId, MongoHelper mongoHelper) async {
    var update = mongo.modify.pullAll('allParticipants',
        users.map((e) => mongo.ObjectId.fromHexString(e.id)).toList());
    await RoomModelController(mongoHelper: mongoHelper)
        .updateData(update, roomId);
  }

  static Future<List<Message>> getMessages(
      MongoHelper mongoHelper, String roomId) async {
    var room = await getRoom(mongoHelper, roomId);
    if (room == null) {
      throw Exception('The given roomId does not exits');
    }
    return await MessageHelper.getMessages(mongoHelper, room.messageIds);
  }

  static Stream<List<Message>> getMessagesStream(
      MongoHelper mongoHelper, String roomId) async* {
    var room = await getRoom(mongoHelper, roomId);
    if (room == null) {
      throw Exception('The given roomId does not exits');
    }
    yield* MessageHelper.getMessagesStream(mongoHelper, room.messageIds);
  }

  static Future<List<RoomModel>> getRooms(
          List<String> roomIds, MongoHelper mongoHelper) async =>
      await RoomModelController(mongoHelper: mongoHelper)
          .getDataFromIds(roomIds);
  static Stream<List<RoomModel>> getRoomsStream(
          List<String> roomIds, MongoHelper mongoHelper) =>
      RoomModelController(mongoHelper: mongoHelper)
          .getDataStreamFromIds(roomIds);
  static Future<RoomModel?> getRoom(MongoHelper mongoHelper, String id) async =>
      await RoomModelController(mongoHelper: mongoHelper).getSingleDocument(id);
  Stream<RoomModel> getRoomStream(MongoHelper mongoHelper, String id) =>
      RoomModelController(mongoHelper: mongoHelper).getSingleDocumentStream(id);

  static Future<void> addMessage(
      MongoHelper mongoHelper, Message message, String roomId) async {
    String id = await MessageHelper.addMessage(mongoHelper, message);
    var update = mongo.modify.push('messageIds', id);
    await RoomModelController(mongoHelper: mongoHelper)
        .updateData(update, roomId);
  }

  static Future<void> addOrUpdateDescription(
      String description, String roomId, MongoHelper mongoHelper) async {
    var update = mongo.modify.set('description', description);
    RoomModelController(mongoHelper: mongoHelper).updateData(update, roomId);
  }

  static Future<void> addAdmin(String userId, String targetUserId,
      String roomId, MongoHelper mongoHelper) async {
    var room = await getRoom(mongoHelper, roomId);
    if (room == null) {
      throw Exception('The given roomId does not exits');
    }
    if (!(room.admins.contains(userId))) {
      throw Exception('Current user does not have permission to add admin');
    }
    if (!room.allParticipants.contains(userId)) {
      throw Exception('Current user is not a part of this group');
    }
    if (!room.admins.contains(targetUserId)) {
      throw Exception('Target user is already added as admin');
    }
    if (!room.allParticipants.contains(targetUserId)) {
      throw Exception('Target user is not a part of this group');
    }
    var update = mongo.modify.push('admins', targetUserId);
    await RoomModelController(mongoHelper: mongoHelper)
        .updateData(update, roomId);
  }
}
