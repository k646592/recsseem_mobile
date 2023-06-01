import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  ChatMessage(this.id, this.message, this.users, this.time);
  String id;
  String message;
  types.User users;
  int time;
}