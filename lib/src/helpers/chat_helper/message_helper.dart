// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/src/helpers/chat_helper/read_by_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';

class MessageHelper {
  final MongoConfig _mongoConfig;

  // Constructor to initialize the _mongoConfig
  MessageHelper(this._mongoConfig);
  Future<void> createIndex() async =>
      await MessageController(mongoConfig: _mongoConfig).createIndex();

  Future<List<Message>> getMessages(List<String> messagesIds) async {
    return await MessageController(mongoConfig: _mongoConfig)
        .getDataFromIds(messagesIds);
  }

  Stream<List<Message>> getMessagesStream(List<String> messagesIds) {
    return MessageController(mongoConfig: _mongoConfig)
        .getDataStreamFromIds(messagesIds);
  }

  Future<String> addMessage(Message message) async {
    return await MessageController(mongoConfig: _mongoConfig)
        .addData(message, docId: message.id);
  }

  Future<Message?> getSingleMessage(String messageId) async {
    return await MessageController(mongoConfig: _mongoConfig)
        .getSingleDocument(messageId);
  }

  Stream<Message?> getSingleMessageStream(String messageId) {
    return MessageController(mongoConfig: _mongoConfig)
        .getSingleDocumentStream(messageId);
  }

  Future<MessageReadBy?> getReadyByList(String messageId) async {
    var message = await getSingleMessage(messageId);
    if (message == null) {
      throw Exception('Message does not exist');
    }
    return await MessageReadByHelper(_mongoConfig).getReadBy(
      messageId,
    );
  }

  Stream<MessageReadBy?> getReadyByStream(String messageId) async* {
    var message = await getSingleMessage(messageId);
    if (message == null) {
      throw Exception('Message does not exist');
    }
    yield* MessageReadByHelper(_mongoConfig).getReadByStream(messageId);
  }
}
