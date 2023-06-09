import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/chat_room.dart';

class MyModel extends ChangeNotifier {

  List<ChatRoom> chats = [];

  List<dynamic> joinChatRooms = [];

  String email = '';
  String name = '';
  String group = '';
  String grade = '';
  String status = '';
  String imgURL = '';

  void fetchMyModel() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    email = userSnapshot.data()!['email'];
    name = userSnapshot.data()!['name'];
    group = userSnapshot.data()!['group'];
    grade = userSnapshot.data()!['grade'];
    status = userSnapshot.data()!['status'];
    joinChatRooms = userSnapshot.data()!['joinChatRooms'];
    imgURL = userSnapshot.data()!['imgURL'];
    notifyListeners();

    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('rooms').orderBy('createdAt').get();

    final List<ChatRoom> rooms = snap.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String roomName = data['roomName'];
      final List<dynamic> admin = data['admin'].toList();
      final String recentMessage = data['recentMessage'];
      final String recentMessageSender = data['recentMessageSender'];
      final DateTime createdAt = data['createdAt'].toDate();
      final List<dynamic> members = data['members'].toList();
      final String imgURL = data['imgURL'];
      return ChatRoom(id, roomName, admin, recentMessage, recentMessageSender, createdAt, members, imgURL);
    }).toList();

    for (var room in rooms) {
      for(int i = 0; i<joinChatRooms.length; i++){
        if(joinChatRooms[i] == room.id){
          chats.add(room);
        }
      }
    }

    notifyListeners();
  }

}