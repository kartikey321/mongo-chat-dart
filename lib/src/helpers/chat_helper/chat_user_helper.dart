import 'package:mongo_chat_dart/mongo_chat_dart.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/dm_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/chat_helper/room_model_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';

class ChatUserHelper {
  final MongoConfig _mongoConfig;

  ChatUserHelper(this._mongoConfig);
  Future<void> createIndex() async =>
      await ChatUserController(mongoConfig: _mongoConfig).createIndex();

  Future<List<ChatUser>> getAllUsers() async {
    return await ChatUserController(mongoConfig: _mongoConfig).getData();
  }

  Future<String> addUser(
    ChatUser chatUser,
  ) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .addData(chatUser, docId: chatUser.id);
  }

  Future<ChatUser?> getChatUser(String userId) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .getSingleDocument(userId);
  }

  Future<List<ChatUser>> getChatUserFromProps(
      {String? email, String? userName}) async {
    assert(!(email == null && userName == null),
        'Atlease one of email or username should be not null');
    return await ChatUserController(mongoConfig: _mongoConfig)
        .getData(filters: [
      DataFilterWrapper(filterType: DataFilterWrapperType.and, filters: [
        if (email != null)
          DataFilter(
              fieldName: 'email',
              value: email,
              filterType: DataFilterType.isEqualTo),
        if (userName != null)
          DataFilter(
              fieldName: 'userName',
              value: email,
              filterType: DataFilterType.isEqualTo),
      ])
    ]);
  }

  Future<List<ChatUser>> getUsers(List<String> userIds) async {
    return await ChatUserController(mongoConfig: _mongoConfig)
        .getDataFromIds(userIds);
  }

  Stream<List<ChatUser>> getUsersStream(List<String> userIds) {
    return ChatUserController(mongoConfig: _mongoConfig)
        .getDataStreamFromIds(userIds);
  }

  Stream<List<ChatUser>> getAllUsersStream() {
    return ChatUserController(mongoConfig: _mongoConfig).getDataStream();
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
