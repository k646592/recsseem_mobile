class ChatRoom {
  ChatRoom(this.id, this.roomName, this.admin, this.resentMessage, this.resentMessageSender, this.createdAt, this.members);
  String id;
  String roomName;
  List<dynamic> admin;
  String resentMessage;
  String resentMessageSender;
  DateTime createdAt;
  List<dynamic> members;
}
