# MongoChatDart 💬

MongoChatDart is a powerful Dart package designed to simplify the implementation of chat functionality in your applications. It provides a robust backend solution for managing users, direct messages, group chats, and more, all powered by MongoDB.

## ✨ Features

-  **Easy Setup**: Get your chat system up and running with just a few lines of code.
-  **MongoDB Integration**: Utilize your own MongoDB database for data storage and management.
-  **User Management**: Easily create, retrieve, and manage user profiles.
-  **Direct Messaging**: Support for one-on-one conversations between users.
-  **Group Chats**: Create and manage group conversations with multiple participants.
-  **Message Management**: Send, retrieve, and manage messages within conversations.
-  **Read Receipts**: Track when messages have been read by recipients.
-  **Real-time Updates**: Utilize streams for real-time message and chat room updates.
-  **Scalable**: Designed to handle growing user bases and increasing message volumes.

## 🚀 Getting Started

### 📦 Installation

Add MongoChatDart to your `pubspec.yaml` file:

```yaml
dependencies:
  mongo_chat_dart: ^1.0.0
```

Then run:

```
dart pub get
```

### 🔧 Basic Usage

1. Initialize MongoChatDart with your MongoDB connection string:

```dart
import 'package:mongo_chat_dart/mongo_chat_dart.dart';

void main() async {
  final mongoChatDart = MongoChatDart();
  await mongoChatDart.initialize('mongodb://localhost:27017/your_database');

  // Your chat application logic here
}
```

2. Create a new user:

```dart
final user = ChatUser(
  name: 'John Doe',
  userName: 'johndoe',
  emailId: 'john@example.com',
);

await mongoChatDart.chatUser.addUser(user);
```

3. Create a DM room:

```dart
final dmRoom = DmModel(
  participant1Id: user1.id,
  participant2Id: user2.id,
  createdOn: DateTime.now(),
);

await mongoChatDart.dmModel.createDmRoom(dmRoom);
```

4. Send a message:

```dart
final message = ChatMessage(
  text: 'Hello!',
  sentAt: DateTime.now(),
  sentBy: user1.id,
);

await mongoChatDart.dmModel.addMessage(message, dmRoom.id);
```

5. Retrieve messages:

```dart
final messages = await mongoChatDart.message.getMessages(dmRoom.messageIds);
```

6. Listen for real-time updates:

```dart
mongoChatDart.dmModel.getDmRoomsStream([dmRoom.id]).listen((dmRooms) {
  // Handle updates to DM rooms
});
```

## 📚 Documentation

For more detailed information on how to use MongoChatDart, please refer to our [API documentation](example/mongo_chat_dart_example.dart).

## 🗺️ Roadmap

We're constantly working to improve MongoChatDart. Here are some features we're planning to add in the future:

- 📱 Client-side package for easy UI integration
- 🔐 End-to-end encryption for messages
- 📵 Offline message support
- 📎 File and media sharing
- 🔍 Advanced search functionality
- 📊 Analytics and reporting tools

## 🤝 Contributing

We welcome contributions to MongoChatDart! Please see our [contributing guidelines](contribution.md) for more information on how to get involved.

## 📄 License

MongoChatDart is released under the [BSD 3-Clause License](LICENSE).

## 🆘 Support

If you encounter any issues or have questions about using MongoChatDart, please [open an issue](https://github.com/kartikey321/mongo-chat-dart/issues) on our GitHub repository.

---

We hope MongoChatDart helps you build amazing chat features in your applications quickly and efficiently. Happy coding! 🎉