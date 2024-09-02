import 'package:mongo_chat_dart/mongo_chat_dart.dart';

void main() {
  var mongoChat=MongoChatDart();

  //User methods
  mongoChat.chatUser.addUser(ChatUser(name: 'Ravi',emailId: 'ravi123@gmail.com',phoneNo: '1234567890'))
}
