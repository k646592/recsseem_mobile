import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/chat_room.dart';

class ChatRoomListModel extends ChangeNotifier {

  List<ChatRoom> chatRooms = [];

  List<dynamic> joinChatRooms = [];

  String? email;
  String? name;
  String? group;
  String? grade;
  String? status;

  void fetchChatRoomList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    joinChatRooms = userSnapshot.data()!['joinChatRooms'];

    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('rooms').orderBy('createdAt').get();

    final List<ChatRoom> rooms = snap.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String roomName = data['roomName'];
      final List<dynamic> admin = data['admin'].toList();
      final String resentMessage = data['resentMessage'];
      final String resentMessageSender = data['resentMessageSender'];
      final DateTime createdAt = data['createdAt'].toDate();
      final List<dynamic> members = data['members'].toList();
      return ChatRoom(id, roomName, admin, resentMessage, resentMessageSender, createdAt, members);
    }).toList();

      for (var room in rooms) {
        for(int i = 0; i<joinChatRooms.length; i++){
          if(joinChatRooms[i] == room.id){
            chatRooms.add(room);
          }
        }
      }

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      name = snapshot.get('name');
      group = snapshot.get('group');
      grade = snapshot.get('grade');
      email = snapshot.get('email');
      status = snapshot.get('status');
    });

    notifyListeners();
  }
}