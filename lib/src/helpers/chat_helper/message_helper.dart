import 'package:mongo_chat_dart/src/helpers/chat_helper/read_by_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';

class MessageHelper {
  static Future<List<Message>> getMessages(
          MongoHelper mongoHelper, List<String> messagesIds) async =>
      await MessageController(mongoHelper: mongoHelper)
          .getDataFromIds(messagesIds);

  static Stream<List<Message>> getMessagesStream(
          MongoHelper mongoHelper, List<String> messagesIds) =>
      MessageController(mongoHelper: mongoHelper)
          .getDataStreamFromIds(messagesIds);

  static Future<String> addMessage(
          MongoHelper mongoHelper, Message message) async =>
      await MessageController(mongoHelper: mongoHelper).addData(message);

  static Future<Message?> getSingleMessage(
          MongoHelper mongoHelper, String messageId) async =>
      await MessageController(mongoHelper: mongoHelper)
          .getSingleDocument(messageId);
  static Stream<Message> getSingleMessageStream(
          MongoHelper mongoHelper, String messageId) =>
      MessageController(mongoHelper: mongoHelper)
          .getSingleDocumentStream(messageId);

  static Future<MessageReadBy?> getReadyByList(
      MongoHelper mongoHelper, String messageId) async {
    var message = getSingleMessage(mongoHelper, messageId);
    if (message == null) {
      throw Exception('Message does not exist');
    }
    return await MessageReadByHelper.getReadBy(messageId, mongoHelper);
  }

  static Stream<MessageReadBy> getReadyByStream(
      MongoHelper mongoHelper, String messageId) async* {
    var message = getSingleMessage(mongoHelper, messageId);
    if (message == null) {
      throw Exception('Message does not exist');
    }
    yield* MessageReadByHelper.getReadByStream(messageId, mongoHelper);
  }
}
