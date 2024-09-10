// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/src/helpers/chat_helper/message_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/message.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class DMModelHelper {
  final MongoConfig _mongoConfig;

  // Constructor to initialize the _mongoConfig
  DMModelHelper(this._mongoConfig);

  Future<void> createIndex() async =>
      await DmModelController(mongoConfig: _mongoConfig).createIndex();

  Future<void> createDmRoom(DmModel dmModel) async {
    await DmModelController(mongoConfig: _mongoConfig)
        .addData(dmModel, docId: dmModel.id);
    var update = mongo.modify.push('dmRooms', dmModel.id);
    await Future.wait([
      ChatUserController(mongoConfig: _mongoConfig)
          .updateData(update, dmModel.participant1Id),
      ChatUserController(mongoConfig: _mongoConfig)
          .updateData(update, dmModel.participant2Id)
    ]);
  }

  Future<List<DmModel>> getDmRooms(List<String> ids) async {
    return await DmModelController(mongoConfig: _mongoConfig)
        .getDataFromIds(ids);
  }

  Stream<List<DmModel>> getDmRoomsStream(List<String> ids) {
    return DmModelController(mongoConfig: _mongoConfig)
        .getDataStreamFromIds(ids);
  }

  Future<void> addMessage(Message message, String dmRoomId) async {
    String id = await MessageHelper(_mongoConfig).addMessage(
      message,
    );
    var update = mongo.modify.push('messageIds', id);
    await DmModelController(mongoConfig: _mongoConfig)
        .updateData(update, dmRoomId);
  }
}
