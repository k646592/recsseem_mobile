import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  ChatMessage(this.id, this.message, this.users, this.time);
  String id;
  String message;
  types.User users;
  int time;
}

class ChatNewMessage {
  ChatNewMessage(this.id, this.message, this.senderId, this.time, this.sendImg, this.height, this.width, this.name, this.size);
  String id;
  String message;
  String senderId;
  int time;
  String sendImg;
  int height;
  int width;
  String name;
  int size;
}