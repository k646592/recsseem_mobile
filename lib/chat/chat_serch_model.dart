import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/chat_room.dart';

class ChatSearchModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool hasUserSearched = false;

  List<ChatRoom> chatRooms = [];
  List<dynamic> joinChatRooms = [];


  initiateSearchMethod(bool isLoading) async {
    if(searchController.text.isNotEmpty) {
      isLoading = true;
      searchByName(searchController.text);
      notifyListeners();
    }
  }

  void searchByName(String roomName) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('rooms').where('roomName', isEqualTo: roomName).get();
    final List<ChatRoom> rooms = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String roomName = data['roomName'];
      final List<dynamic> admin = data['admin'].toList();
      final String recentMessage = data['recentMessage'];
      final String recentMessageSender = data['recentMessageSender'];
      final DateTime createdAt = data['createdAt'].toDate();
      final List<dynamic> members = data['members'].toList();
      final String imgURl = data['imgURL'];
      return ChatRoom(id, roomName, admin, recentMessage, recentMessageSender, createdAt, members, imgURl);
    }).toList();

    chatRooms = rooms;
    notifyListeners();
  }

  void fetchChatSearch() async {
    final user = FirebaseAuth.instance.currentUser;


    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      joinChatRooms = snapshot.get('joinChatRooms');
    });

    joinChatRooms.forEach((room) {
      for(int i=0; i<chatRooms.length; i++) {
        if(chatRooms[i].id == room) {
          chatRooms.removeAt(i);
          break;
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  Future entryRoom(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'joinChatRooms': FieldValue.arrayUnion([id]),
    });

    FirebaseFirestore.instance.collection('rooms').doc(id).update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
    notifyListeners();
  }

}