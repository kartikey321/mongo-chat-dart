import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/message_read_by.dart';
import 'package:mongo_chat_dart/src/models/readby.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MessageReadByHelper {
  final MongoConfig _mongoConfig;

  // Constructor to initialize the _mongoConfig
  MessageReadByHelper(this._mongoConfig);

    Future<void> createIndex() async=>await MessageReadByController(mongoConfig: _mongoConfig).createIndex();


  Future<MessageReadBy?> getReadBy(String readById) async {
    return await MessageReadByController(mongoConfig: _mongoConfig).getSingleDocument(readById);
  }

  Stream<MessageReadBy?> getReadByStream(String readById) {
    return MessageReadByController(mongoConfig: _mongoConfig).getSingleDocumentStream(readById);
  }

  Future<void> addReadBy(ReadBy readBy, String messageId) async {
    var update = mongo.modify.push('readByList', readBy);
    await MessageReadByController(mongoConfig: _mongoConfig).updateData(update, messageId);
  }
}

