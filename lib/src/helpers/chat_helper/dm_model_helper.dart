import 'package:mongo_chat_dart/src/helpers/chat_helper/message_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class DMModelHelper {
//   Future<void> addUsersToDmRoom(MongoHelper mongoHelper,List<ChatUser> users,String roomId) async{
// var update=mongo.modify.pushAll()
// DmModelController(mongoHelper: mongoHelper).updateData(update, id)
//   }

  static Future<String> createDmRoom(
          MongoHelper mongoHelper, DmModel dmModel) async =>
      await DmModelController(mongoHelper: mongoHelper).addData(dmModel);

  static Future<List<DmModel>> getDmRooms(
          MongoHelper mongoHelper, List<String> ids) async =>
      await DmModelController(mongoHelper: mongoHelper).getDataFromIds(ids);
  static Stream<List<DmModel>> getDmRoomsStream(
          MongoHelper mongoHelper, List<String> ids) =>
      DmModelController(mongoHelper: mongoHelper).getDataStreamFromIds(ids);
  static Future<void> addMessage(
      MongoHelper mongoHelper, Message message, String dmRoomId) async {
    String id = await MessageHelper.addMessage(mongoHelper, message);
    var update = mongo.modify.push('messageIds', id);
    await DmModelController(mongoHelper: mongoHelper)
        .updateData(update, dmRoomId);
  }
}
