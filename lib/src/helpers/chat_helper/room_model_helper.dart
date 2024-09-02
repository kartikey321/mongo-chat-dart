import 'package:mongo_chat_dart/src/helpers/chat_helper/message_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RoomModelHelper {
  final MongoConfig _mongoConfig;

  // Constructor to initialize the _mongoConfig
  RoomModelHelper(this._mongoConfig);

  Future<void> createIndex() async =>
      await RoomModelController(mongoConfig: _mongoConfig).createIndex();

  Future<String> createRoom(RoomModel roomModel,) async {
    return await RoomModelController(mongoConfig: _mongoConfig)
        .addData(roomModel,docId: roomModel.id);
  }

  Future<void> addParticipants(List<ChatUser> users, String roomId) async {
    var update = mongo.modify.pullAll(
      'allParticipants',
      users.map((e) => mongo.ObjectId.fromHexString(e.id)).toList(),
    );
    await RoomModelController(mongoConfig: _mongoConfig)
        .updateData(update, roomId);
  }

  Future<List<Message>> getMessages(String roomId) async {
    var room = await getRoom(roomId);
    if (room == null) {
      throw Exception('The given roomId does not exist');
    }
    return await MessageHelper(_mongoConfig).getMessages(room.messageIds);
  }

  Stream<List<Message>> getMessagesStream(String roomId) async* {
    var room = await getRoom(roomId);
    if (room == null) {
      throw Exception('The given roomId does not exist');
    }
    yield* MessageHelper(_mongoConfig).getMessagesStream(room.messageIds);
  }

  Future<List<RoomModel>> getRooms(List<String> roomIds) async {
    return await RoomModelController(mongoConfig: _mongoConfig)
        .getDataFromIds(roomIds);
  }

  Stream<List<RoomModel>> getRoomsStream(List<String> roomIds) {
    return RoomModelController(mongoConfig: _mongoConfig)
        .getDataStreamFromIds(roomIds);
  }

  Future<RoomModel?> getRoom(String id) async {
    return await RoomModelController(mongoConfig: _mongoConfig)
        .getSingleDocument(id);
  }

  Stream<RoomModel> getRoomStream(String id) {
    return RoomModelController(mongoConfig: _mongoConfig)
        .getSingleDocumentStream(id);
  }

  Future<void> addMessage(Message message, String roomId) async {
    String id = await MessageHelper(_mongoConfig).addMessage(message);
    var update = mongo.modify.push('messageIds', id);
    await RoomModelController(mongoConfig: _mongoConfig)
        .updateData(update, roomId);
  }

  Future<void> addOrUpdateDescription(String description, String roomId) async {
    var update = mongo.modify.set('description', description);
    await RoomModelController(mongoConfig: _mongoConfig)
        .updateData(update, roomId);
  }

  Future<void> addAdmin(
      String userId, String targetUserId, String roomId) async {
    var room = await getRoom(roomId);
    if (room == null) {
      throw Exception('The given roomId does not exist');
    }
    if (!room.admins.contains(userId)) {
      throw Exception('Current user does not have permission to add admin');
    }
    if (!room.allParticipants.contains(userId)) {
      throw Exception('Current user is not a part of this group');
    }
    if (room.admins.contains(targetUserId)) {
      throw Exception('Target user is already added as admin');
    }
    if (!room.allParticipants.contains(targetUserId)) {
      throw Exception('Target user is not a part of this group');
    }
    var update = mongo.modify.push('admins', targetUserId);
    await RoomModelController(mongoConfig: _mongoConfig)
        .updateData(update, roomId);
  }
}
