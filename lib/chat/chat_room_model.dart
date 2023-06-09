import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/chat_room.dart';
import '../domain/user_data.dart';

class ChatRoomListModel extends ChangeNotifier {

  List<ChatRoom> chatRooms = [];

  List<dynamic> joinChatRooms = [];

  List<UserData> userData = [];

  List<String> docList = [];

  String? myId;
  String? partnerId;
  String? email;
  String? name;
  String? group;
  String? grade;
  String? status;

  void fetchChatRoomList() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final QuerySnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').get();
    final List<UserData> userData = userDataSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = data['uid'];
      final String email = data['email'];
      final String grade = data['grade'];
      final String group = data['group'];
      final String name = data['name'];
      final String status = data['status'];
      final String imgURL = data['imgURL'];
      return UserData(id, email, grade, group, name, status, imgURL);
    }).toList();

    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    joinChatRooms = userSnapshot.data()!['joinChatRooms'];

    UserData myData = UserData(userSnapshot.data()!['uid'], userSnapshot.data()!['email'], userSnapshot.data()!['grade'], userSnapshot.data()!['group'], userSnapshot.data()!['name'], userSnapshot.data()!['status'], userSnapshot.data()!['imgURL']);

    for(var i=0; i<userData.length; i++) {
      if(userData[i].id == myData.id) {
        userData.removeAt(i);
        break;
      }
    }

    this.userData = userData;

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
            chatRooms.add(room);
          }
        }
      }

    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots().listen((DocumentSnapshot snapshot) {
      name = snapshot.get('name');
      group = snapshot.get('group');
      grade = snapshot.get('grade');
      email = snapshot.get('email');
      status = snapshot.get('status');
    });

    notifyListeners();
  }

    Future individualChat(String uid) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final QuerySnapshot docSnap = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('privateChat').get();

    final List<String> chats = docSnap.docs.map((DocumentSnapshot document) {
      final String id = document.id;
      return id;
    }).toList();

    docList = chats;

    if(docList.isEmpty) {
      //新しい個人チャットルームの作成
      final doc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('privateChat').doc(uid);
      //FireStoreに追加
      doc.set ({
        'partnerId': uid,
        'createdAt': DateTime.now(),
        'recentMessage': '',
        'recentMessageSender': '',
      });
      final partnerDoc = FirebaseFirestore.instance.collection('users').doc(uid).collection('privateChat').doc(currentUser.uid);
      //FireStoreに追加
      partnerDoc.set ({
        'partnerId': currentUser.uid,
        'createdAt': DateTime.now(),
        'recentMessage': '',
        'recentMessageSender': '',
      });
    }

    else {
      docList.forEach((doc) {
        if( doc == uid ) {
          //既にチャットルームが存在
          partnerId = uid;
          myId = currentUser.uid;
        }
        else {
          //チャットルームが存在しないため、新たに作成
          final doc = FirebaseFirestore.instance.collection('user').doc(currentUser.uid).collection('privateChat').doc(uid);
          //FireStoreに追加
          doc.set ({
            'partnerId': uid,
            'createdAt': DateTime.now(),
            'recentMessage': '',
            'recentMessageSender': '',
          });
          final partnerDoc = FirebaseFirestore.instance.collection('user').doc(uid).collection('privateChat').doc(currentUser.uid);
          //FireStoreに追加
          partnerDoc.set ({
            'partnerId': currentUser.uid,
            'createdAt': DateTime.now(),
            'recentMessage': '',
            'recentMessageSender': '',
          });

          partnerId = uid;
          myId = currentUser.uid;
        }
      });
    }
    notifyListeners();
  }

}