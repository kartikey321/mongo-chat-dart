import 'package:mongo_chat_dart/src/helpers/chat_helper/chat_user_helper.dart';
import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/dm_model.dart';
import 'package:mongo_chat_dart/src/models/room_model.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('ChatUserHelper', () {
    late ChatUserController mockChatUserController;

    late ChatUserHelper chatUserHelper;
 final user = ChatUser( name: 'John Doe', dmRooms: [], rooms: []);
    setUp(() async {
      final mongoConfig = MongoConfig(
          'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/test1');
      await mongoConfig.initialize();
      mockChatUserController = ChatUserController(mongoConfig: mongoConfig);

      chatUserHelper = ChatUserHelper(mongoConfig);
      await chatUserHelper.createIndex();
    });
    test('addUser calls addData on ChatUserController', () async {
     

      var data = await chatUserHelper.addUser(user);
      print(data);
    });
    test('getAllUsers returns a list of ChatUser', () async {
      final userList = [
       user
      ];

      final result = await chatUserHelper.getAllUsers();

      expect(result, userList);
    });

    test('getChatUser returns a ChatUser', () async {
     

      final result = await chatUserHelper.getChatUser(user.id);

      expect(result, user);
    });

    test('getUsers returns a list of ChatUser', () async {
      final userList = [
user      ];

      final result = await chatUserHelper.getUsers(userList.map((e)=>e.id).toList());

      expect(result, userList);
    });

    // test('getUsersStream returns a stream of ChatUser list', () async {
    //   final userList = [
    //     ChatUser(id: '1', name: 'John Doe', dmRooms: [], rooms: []),
    //   ];

    //   final result = chatUserHelper.getUsersStream([user1Id]);
    //   final resultList = await result.toList();

    //   expect(resultList, [userList]);
    // });

    // test('addDmRoom adds a DM model to a user', () async {
    //   final dmModel = DmModel(id: 'dm1', name: 'New DM');
    //   final userId = 'user1';

    //   await chatUserHelper.addDmRoom(dmModel, userId);

    //   final update = mongo.modify.push('dmRooms', 'dm1');
    //   verify(mockChatUserController.updateData(update, userId)).called(1);
    // });

    // test('getDmChats returns a list of DmModel', () async {
    //   final user = ChatUser(id: '1', name: 'John Doe', dmRooms: ['dm1', 'dm2'], rooms: []);
    //   final dmModels = [
    //     DmModel(id: 'dm1', name: 'DM1'),
    //     DmModel(id: 'dm2', name: 'DM2'),
    //   ];

    //   when(mockChatUserController.getSingleDocument('1')).thenAnswer((_) async => user);
    //   when(mockDMModelHelper.getDmRooms(['dm1', 'dm2'])).thenAnswer((_) async => dmModels);

    //   final result = await chatUserHelper.getDmChats('1');

    //   expect(result, dmModels);
    //   verify(mockChatUserController.getSingleDocument('1')).called(1);
    //   verify(mockDMModelHelper.getDmRooms(['dm1', 'dm2'])).called(1);
    // });

    // test('getRoomChats returns a list of RoomModel', () async {
    //   final user = ChatUser(id: '1', name: 'John Doe', dmRooms: [], rooms: ['room1', 'room2']);
    //   final roomModels = [
    //     RoomModel(id: 'room1', name: 'Room1'),
    //     RoomModel(id: 'room2', name: 'Room2'),
    //   ];

    //   when(mockChatUserController.getSingleDocument('1')).thenAnswer((_) async => user);
    //   when(mockRoomModelHelper.getRooms(['room1', 'room2'])).thenAnswer((_) async => roomModels);

    //   final result = await chatUserHelper.getRoomChats('1');

    //   expect(result, roomModels);
    //   verify(mockChatUserController.getSingleDocument('1')).called(1);
    //   verify(mockRoomModelHelper.getRooms(['room1', 'room2'])).called(1);
    // });

    // test('getRoomChatsStream returns a stream of RoomModel list', () async {
    //   final user = ChatUser(id: '1', name: 'John Doe', dmRooms: [], rooms: ['room1', 'room2']);
    //   final roomModels = [
    //     RoomModel(id: 'room1', name: 'Room1'),
    //     RoomModel(id: 'room2', name: 'Room2'),
    //   ];

    //   when(mockChatUserController.getSingleDocument('1')).thenAnswer((_) async => user);
    //   when(mockRoomModelHelper.getRoomsStream(['room1', 'room2'])).thenAnswer((_) => Stream.fromIterable([roomModels]));

    //   final result = chatUserHelper.getRoomChatsStream('1');
    //   final resultList = await result.toList();

    //   expect(resultList, [roomModels]);
    //   verify(mockChatUserController.getSingleDocument('1')).called(1);
    //   verify(mockRoomModelHelper.getRoomsStream(['room1', 'room2'])).called(1);
    // });

    // test('getDmChatsStream returns a stream of DmModel list', () async {
    //   final user = ChatUser(id: '1', name: 'John Doe', dmRooms: ['dm1', 'dm2'], rooms: []);
    //   final dmModels = [
    //     DmModel(id: 'dm1', name: 'DM1'),
    //     DmModel(id: 'dm2', name: 'DM2'),
    //   ];

    //   when(mockChatUserController.getSingleDocument('1')).thenAnswer((_) async => user);
    //   when(mockDMModelHelper.getDmRoomsStream(['dm1', 'dm2'])).thenAnswer((_) => Stream.fromIterable([dmModels]));

    //   final result = chatUserHelper.getDmChatsStream('1');
    //   final resultList = await result.toList();

    //   expect(resultList, [dmModels]);
    //   verify(mockChatUserController.getSingleDocument('1')).called(1);
    //   verify(mockDMModelHelper.getDmRoomsStream(['dm1', 'dm2'])).called(1);
    // });
  });
}
