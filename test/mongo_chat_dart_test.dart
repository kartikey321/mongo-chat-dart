// import 'package:mongo_chat_dart/src/helpers/chat_helper/chat_user_helper.dart';
// import 'package:mongo_chat_dart/src/helpers/controllers/controllers.dart';
// import 'package:mongo_chat_dart/src/models/chat_user.dart';
// import 'package:mongo_chat_dart/src/models/dm_model.dart';
// import 'package:mongo_chat_dart/src/models/room_model.dart';
// import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
// import 'package:test/expect.dart';
// import 'package:test/scaffolding.dart';

// void main() {
//   group('ChatUserHelper', () {
//     late ChatUserController mockChatUserController;

//     late ChatUserHelper chatUserHelper;
//  final user = ChatUser( name: 'John Doe', dmRooms: [], rooms: []);
//     setUp(() async {
//       final mongoConfig = MongoConfig(
//           'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/test1');
//       await mongoConfig.initialize();
//       mockChatUserController = ChatUserController(mongoConfig: mongoConfig);

//       chatUserHelper = ChatUserHelper(mongoConfig);
//       await chatUserHelper.createIndex();
//     });
//     test('addUser calls addData on ChatUserController', () async {
     

//       var data = await chatUserHelper.addUser(user);
//       print(data);
//     });
//     test('getAllUsers returns a list of ChatUser', () async {
//       final userList = [
//        user
//       ];

//       final result = await chatUserHelper.getAllUsers();

//       expect(result, userList);
//     });

//     test('getChatUser returns a ChatUser', () async {
     

//       final result = await chatUserHelper.getChatUser(user.id);

//       expect(result, user);
//     });

//     test('getUsers returns a list of ChatUser', () async {
//       final userList = [
// user      ];

//       final result = await chatUserHelper.getUsers(userList.map((e)=>e.id).toList());

//       expect(result, userList);
//     });

    
//   });
// }
