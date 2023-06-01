import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../domain/chat_message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class ChatPageModel extends ChangeNotifier {

  final String roomId;
  ChatPageModel({Key? key, required this.roomId,}) : super();

  final List<types.Message> messages = [];

  types.User? myUser;

  //メッセージの受け取り
  void fetchChatMessageList() async {
    final user = FirebaseAuth.instance.currentUser;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('messages').orderBy('time').get();

    final List<ChatMessage> chatMessages = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String message = data['message'];
      final String senderId = data['senderId'];
      final String senderName = data['senderName'];
      final String imgURL = data['imgURL'];
      final types.User users = types.User(
        id: senderId,
        firstName: senderName,
        imageUrl: imgURL,
      );
      final int time = data['time'];
      return ChatMessage(id, message, users, time);
    }).toList();

    for (int i=0; i<chatMessages.length; i++){
      _addMessage(types.TextMessage(
        author: chatMessages[i].users,
        createdAt: chatMessages[i].time,
        id: chatMessages[i].id,
        text: chatMessages[i].message,
        status: types.Status.delivered,
      ));
    }

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      myUser = types.User(
        id: snapshot.get('uid'),
        firstName: snapshot.get('name'),
        imageUrl: snapshot.get('imgURL'),
      );
    });
    notifyListeners();

  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

  handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: myUser!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);

    Map<String, dynamic> chatMessageMap = {
      'message': message.text,
      'senderId': myUser!.id,
      'senderName': myUser!.firstName,
      'imgURL': myUser!.imageUrl,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    sendMessageStore(roomId, chatMessageMap, randomString());

    notifyListeners();
  }

  Future sendMessageStore(String roomId, Map<String, dynamic> chatMessageData, String random) async {
    FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('messages').doc(random).set(chatMessageData);

    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

  }

}