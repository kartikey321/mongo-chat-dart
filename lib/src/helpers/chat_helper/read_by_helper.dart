import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';
import 'package:mongo_chat_dart/src/models/readby.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MessageReadByHelper {
  static Future<MessageReadBy?> getReadBy(
          String readById, MongoHelper mongoHelper) async =>
      await MessageReadByController(mongoHelper: mongoHelper)
          .getSingleDocument(readById);
  static Stream<MessageReadBy> getReadByStream(
          String readById, MongoHelper mongoHelper) =>
      MessageReadByController(mongoHelper: mongoHelper)
          .getSingleDocumentStream(readById);
  static Future<void> addReadBy(
      MongoHelper mongoHelper, ReadBy readBy, String messageId) async {
    var update = mongo.modify.push('readByList', readBy);
    await MessageReadByController(mongoHelper: mongoHelper)
        .updateData(update, messageId);
  }
}
