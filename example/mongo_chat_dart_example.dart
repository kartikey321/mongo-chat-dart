import 'package:mongo_chat_dart/mongo_chat_dart.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  // Initialize the MongoChatDart instance
  final mongoChatDart = MongoChatDart();
  await mongoChatDart.initialize('mongodb://localhost:27017/chat_app');

  // Create users
  final user1 = ChatUser(
    name: 'Alice Smith',
    userName: 'alice',
    emailId: 'alice@example.com',
    bio: 'Tech enthusiast',
    phoneNo: '+1234567890',
  );
  final user2 = ChatUser(
    name: 'Bob Johnson',
    userName: 'bob',
    emailId: 'bob@example.com',
    bio: 'Sports fan',
    phoneNo: '+0987654321',
  );
  final user3 = ChatUser(
    name: 'Charlie Brown',
    userName: 'charlie',
    emailId: 'charlie@example.com',
    bio: 'Movie buff',
    phoneNo: '+1122334455',
  );

  await mongoChatDart.chatUser.addUser(user1);
  await mongoChatDart.chatUser.addUser(user2);
  await mongoChatDart.chatUser.addUser(user3);

  // Create a DM (Direct ChatMessage) room
  final dmRoom = DmModel(
    participant1Id: user1.id,
    participant2Id: user2.id,
    createdOn: DateTime.now(),
  );

  await mongoChatDart.dmModel.createDmRoom(dmRoom);

  // Send messages in the DM room
  final dmMessage1 = ChatMessage(
    text: 'Hey Bob, how are you?',
    sentAt: DateTime.now(),
    sentBy: user1.id,
  );

  await mongoChatDart.dmModel.addMessage(dmMessage1, dmRoom.id);

  final dmMessage2 = ChatMessage(
    text: 'Hi Alice! I\'m doing great, thanks for asking.',
    sentAt: DateTime.now(),
    sentBy: user2.id,
    replyToMessageId: dmMessage1.id,
  );

  await mongoChatDart.dmModel.addMessage(dmMessage2, dmRoom.id);

  // Create a group chat room
  final groupRoom = RoomModel(
    id: ObjectId().oid,
    name: 'Tech Talk',
    description: 'A place to discuss the latest in technology',
    allParticipants: [user1.id, user2.id, user3.id],
    admins: [user1.id],
    messageIds: [],
    createdBy: user1.id,
    createdAt: DateTime.now(),
  );

  await mongoChatDart.roomModel.createRoom(groupRoom);

  // Send messages in the group chat room
  final groupMessage1 = ChatMessage(
    text: 'Welcome to the Tech Talk group!',
    sentAt: DateTime.now(),
    sentBy: user1.id,
  );

  await mongoChatDart.roomModel.addMessage(groupMessage1, groupRoom.id);

  final groupMessage2 = ChatMessage(
    text: 'Thanks for having me! Excited to discuss tech.',
    sentAt: DateTime.now(),
    sentBy: user3.id,
  );

  await mongoChatDart.roomModel.addMessage(groupMessage2, groupRoom.id);

  // Send a message with a document in the group chat
  final groupMessage3 = ChatMessage(
    text: 'Check out this article on AI advancements!',
    sentAt: DateTime.now(),
    sentBy: user2.id,
  );
  groupMessage3.document = MessageDocument(
    documentUrl: 'https://example.com/ai_article.pdf',
    documentExtension: 'pdf',
    previewDocumentUrl: 'https://example.com/ai_article_preview.jpg',
    previewDocumentExtension: 'jpg',
  );

  await mongoChatDart.roomModel.addMessage(groupMessage3, groupRoom.id);

  // Mark messages as read
  final readBy1 = ReadBy(userId: user2.id, timeStamp: DateTime.now());
  await mongoChatDart.readBy.addReadBy(readBy1, groupMessage1.id);

  final readBy2 = ReadBy(userId: user3.id, timeStamp: DateTime.now());
  await mongoChatDart.readBy.addReadBy(readBy2, groupMessage1.id);

  // Retrieve and print DM messages
  final dmRooms = await mongoChatDart.chatUser.getDmChats(user1.id);
  if (dmRooms.isNotEmpty) {
    final messages =
        await mongoChatDart.message.getMessages(dmRooms[0].messageIds);
    print('Messages in the DM room:');
    for (var msg in messages) {
      if (msg is ChatMessage) {
        print('${msg.sentBy}: ${msg.text}');
        if (msg.replyToMessageId != null) {
          print('  (Reply to: ${msg.replyToMessageId})');
        }
      } else {
        print('${msg.id}: ${msg.text}');
      }
    }
  }

  // Retrieve and print group chat messages
  final groupRooms = await mongoChatDart.chatUser.getRoomChats(user1.id);
  if (groupRooms.isNotEmpty) {
    final messages =
        await mongoChatDart.roomModel.getMessages(groupRooms[0].id);
    print('\nMessages in the group chat room:');
    for (var msg in messages) {
      if (msg is ChatMessage) {
        print('${msg.sentBy}: ${msg.text}');
        if (msg.replyToMessageId != null) {
          print('  (Reply to: ${msg.replyToMessageId})');
        }
      } else {
        print('${msg.id}: ${msg.text}');
      }
    }
  }

  // Stream group chat messages
  print('\nStreaming group chat messages:');
  mongoChatDart.roomModel.getMessagesStream(groupRoom.id).listen((messages) {
    for (var msg in messages) {
      if (msg is ChatMessage) {
        print('${msg.sentBy}: ${msg.text}');
        if (msg.replyToMessageId != null) {
          print('  (Reply to: ${msg.replyToMessageId})');
        }
      } else {
        print('${msg.id}: ${msg.text}');
      }
    }
  });

  // Send another message to the group chat (this will be picked up by the stream)
  await Future.delayed(Duration(seconds: 2));
  final groupMessage4 = ChatMessage(
    text: 'This message should appear in the group chat stream.',
    sentAt: DateTime.now(),
    sentBy: user3.id,
  );
  await mongoChatDart.roomModel.addMessage(groupMessage4, groupRoom.id);

  // Keep the application running to observe the stream
  await Future.delayed(Duration(seconds: 5));

  // Update room description
  await mongoChatDart.roomModel.addOrUpdateDescription(
      'A vibrant community for tech enthusiasts to share and learn.',
      groupRoom.id);

  // Add a new admin to the group
  await mongoChatDart.roomModel.addAdmin(user1.id, user2.id, groupRoom.id);

  // Print updated room details
  final updatedRoom = await mongoChatDart.roomModel.getRoom(groupRoom.id);
  if (updatedRoom != null) {
    print('\nUpdated Group Chat Room Details:');
    print('Name: ${updatedRoom.name}');
    print('Description: ${updatedRoom.description}');
    print('Admins: ${updatedRoom.admins}');
    print('All Participants: ${updatedRoom.allParticipants}');
  }
}
