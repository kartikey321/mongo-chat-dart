// This file is part of the mongo_chat_dart package.
//
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/mongo_chat_dart.dart';
import 'package:test/test.dart';

void main() {
  group('MongoChatDart Tests', () {
    late MongoChatDart mongoChatDart;

    setUp(() async {
      // Initialize with a test database.
      mongoChatDart = MongoChatDart();
      await mongoChatDart.initialize(
          'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/test2');
    });

    tearDown(() async {
      // Clean up database after each test
      await mongoChatDart.dropDatabase();
    });

    test('should create users successfully', () async {
      final user1 = ChatUser(
        name:
            'Alice Smith ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'alice_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'alice@example.com',
        bio: 'Tech enthusiast',
        phoneNo: '+1234567890',
      );
      await mongoChatDart.chatUser.addUser(user1);

      final users = await mongoChatDart.chatUser.getAllUsers();
      expect(users.length, 1);
      expect(users.first.userName, equals(user1.userName));
    });

    test('should create DM room successfully', () async {
      final user1 = ChatUser(
        name:
            'Alice Smith ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'alice_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'alice@example.com',
        bio: 'Tech enthusiast',
        phoneNo: '+1234567890',
      );
      final user2 = ChatUser(
        name:
            'Bob Johnson ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'bob_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'bob@example.com',
        bio: 'Sports fan',
        phoneNo: '+0987654321',
      );

      await mongoChatDart.chatUser.addUser(user1);
      await mongoChatDart.chatUser.addUser(user2);

      final dmRoom = DmModel(
        participant1Id: user1.id,
        participant2Id: user2.id,
        createdOn: DateTime.now(),
      );

      await mongoChatDart.dmModel.createDmRoom(dmRoom);

      final rooms = await mongoChatDart.chatUser.getDmChats(user1.id);
      expect(rooms.length, equals(1));
      expect(rooms.first.participant1Id, equals(user1.id));
      expect(rooms.first.participant2Id, equals(user2.id));
    });

    test('should send message successfully', () async {
      final user1 = ChatUser(
        name:
            'Alice Smith ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'alice_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'alice@example.com',
        bio: 'Tech enthusiast',
        phoneNo: '+1234567890',
      );
      final user2 = ChatUser(
        name:
            'Bob Johnson ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'bob_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'bob@example.com',
        bio: 'Sports fan',
        phoneNo: '+0987654321',
      );
      await mongoChatDart.chatUser.addUser(user1);
      await mongoChatDart.chatUser.addUser(user2);

      final dmRoom = DmModel(
        participant1Id: user1.id,
        participant2Id: user2.id,
        createdOn: DateTime.now(),
      );
      await mongoChatDart.dmModel.createDmRoom(dmRoom);

      final message = ChatMessage(
        text: 'Hey Bob, how are you?',
        sentAt: DateTime.now(),
        sentBy: user1.id,
      );
      await mongoChatDart.dmModel.addMessage(message, dmRoom.id);
      final updatedDmRoom = await mongoChatDart.dmModel
          .getDmRooms([dmRoom.id]).then((val) => val.first);
      final messages =
          await mongoChatDart.message.getMessages(updatedDmRoom.messageIds);
      expect(messages.length, 1);
      expect(messages.first.text, equals('Hey Bob, how are you?'));
    });

    test('should stream messages in real time', () async {
      final user1 = ChatUser(
        name:
            'Alice Smith ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'alice_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'alice@example.com',
        bio: 'Tech enthusiast',
        phoneNo: '+1234567890',
      );
      final user2 = ChatUser(
        name:
            'Bob Johnson ${DateTime.now().millisecondsSinceEpoch}', // Unique name
        userName:
            'bob_${DateTime.now().millisecondsSinceEpoch}', // Unique username
        emailId: 'bob@example.com',
        bio: 'Sports fan',
        phoneNo: '+0987654321',
      );
      await mongoChatDart.chatUser.addUser(user1);
      await mongoChatDart.chatUser.addUser(user2);

      final dmRoom = DmModel(
        participant1Id: user1.id,
        participant2Id: user2.id,
        createdOn: DateTime.now(),
      );
      await mongoChatDart.dmModel.createDmRoom(dmRoom);

      final message = ChatMessage(
        text: 'Hey Bob, how are you?',
        sentAt: DateTime.now(),
        sentBy: user1.id,
      );

      // Listen for new messages
      mongoChatDart.dmModel.getDmRoomsStream([dmRoom.id]).listen((dmRooms) {
        if (dmRooms.isNotEmpty) {
          final messages = dmRooms[0].messageIds;
          for (var msgId in messages) {
            mongoChatDart.message.getSingleMessageStream(msgId).listen((msg) {
              if (msg != null) {
                expect(msg.text, equals('Hey Bob, how are you?'));
              }
            });
          }
        }
      });

      // Send message and trigger the stream
      await mongoChatDart.dmModel.addMessage(message, dmRoom.id);
    });
  });
}
