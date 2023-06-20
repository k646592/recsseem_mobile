import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/chat_message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class IndividualChatPageModel extends ChangeNotifier {

  final String myId;
  final String partnerId;
  IndividualChatPageModel({Key? key, required this.myId, required this.partnerId}) : super();

  final List<types.Message> messages = [];

  types.User? myUser;

  File? imageFile;
  String? img;

  String? imgURL;

  //メッセージの受け取り
  void fetchChatMessageList() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).collection('messages').orderBy('time').get();

    List<ChatNewMessage> chatMessages = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String message = data['message'];
      final String senderId = data['senderId'];
      final int time = data['time'];
      final String sendImg = data['sendImg'];
      final int height = data['height'];
      final int width = data['width'];
      final String name = data['name'];
      final int size = data['size'];

      return ChatNewMessage(id, message, senderId, time, sendImg, height, width, name, size);
    }).toList();

    for (int i=0; i<chatMessages.length; i++){

      if(chatMessages[i].message != ''){
        FirebaseFirestore.instance.collection('users').doc(chatMessages[i].senderId).snapshots().listen((DocumentSnapshot snapshot) {
          _addMessage(types.TextMessage(
            author: types.User(
                id: chatMessages[i].senderId,
                firstName: snapshot.get('name'),
                imageUrl: snapshot.get('imgURL'),
            ),
            createdAt: chatMessages[i].time,
            id: chatMessages[i].id,
            text: chatMessages[i].message,
            status: types.Status.delivered,
          ));
        });
      }
      else {
        FirebaseFirestore.instance.collection('users').doc(chatMessages[i].senderId).snapshots().listen((DocumentSnapshot snapshot) {
          _addMessage(types.ImageMessage(
            author: types.User(
              id: chatMessages[i].senderId,
              firstName: snapshot.get('name'),
              imageUrl: snapshot.get('imgURL'),
            ),
            createdAt: chatMessages[i].time,
            height: chatMessages[i].height.toDouble(),
            id: chatMessages[i].id,
            name: chatMessages[i].name,
            size: chatMessages[i].size,
            uri: chatMessages[i].sendImg,
            width: chatMessages[i].width.toDouble(),
          ));
        });
      }

    }

    FirebaseFirestore.instance.collection('users').doc(myId).snapshots().listen((DocumentSnapshot snapshot) {
      myUser = types.User(
        id: myId,
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
      'sendImg': '',
      'height': 0,
      'name': '',
      'size': 0,
      'width': 0,
      'senderId': myUser!.id,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    sendMessageStore(chatMessageMap, randomString());

    notifyListeners();
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      imageFile = File(result.path);

      if(imageFile!= null) {
        final task = await FirebaseStorage.instance.ref().child('chats/${randomString()}').putFile(imageFile!);
        task.ref.getDownloadURL();
        img = await task.ref.getDownloadURL();
      }
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: myUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: img!,
        width: image.width.toDouble(),
      );

      _addMessage(message);

      Map<String, dynamic> chatImageMap = {
        'message': '',
        'sendImg': message.uri,
        'height': image.height,
        'name': result.name,
        'size': bytes.length,
        'width': image.width,
        'senderId': myUser!.id,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      sendImageStore(chatImageMap, randomString());

      notifyListeners();

    }
  }

  Future sendMessageStore(Map<String, dynamic> chatMessageData, String random) async {
    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).collection('messages').doc(random).set(chatMessageData);
    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).collection('messages').doc(random).set(chatMessageData);

    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

  }

  Future sendImageStore(Map<String, dynamic> chatImageData, String random) async {
    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).collection('messages').doc(random).set(chatImageData);
    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).collection('messages').doc(random).set(chatImageData);

    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).update({
      'recentMessage': chatImageData['sendImg'],
      'recentMessageSender': chatImageData['senderId'],
      'recentMessageTime': chatImageData['time'].toString(),
    });

    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).update({
      'recentMessage': chatImageData['sendImg'],
      'recentMessageSender': chatImageData['senderId'],
      'recentMessageTime': chatImageData['time'].toString(),
    });

  }

}