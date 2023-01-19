import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/user.dart';

class ChatRoomListModel extends ChangeNotifier {
  List<Member> users = [];

  Map<String, List<dynamic>> userGroupList = {};  //key:group, value:user

  String? email;
  String? name;
  String? group;
  String? grade;
  String? status;

  void fetchChatRoomList() async {

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    final List<Member> users = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String email = data['email'];
      final String grade = data['grade'];
      final String group = data['group'];
      final String name = data['name'];
      final String uid = data['uid'];
      final String status = data['status'];
      return Member(id, email, grade, group, name, uid, status);
    }).toList();

    this.users = users;

    this.userGroupList = {};

    users.forEach((user) => {
      if (userGroupList[user.group] != null) {
        userGroupList[user.group]?.add(user)
      }
      else {
        userGroupList[user.group] = [user]
      }
    });

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      this.name = snapshot.get('name');
      this.group = snapshot.get('group');
      this.grade = snapshot.get('grade');
      this.email = snapshot.get('email');
      this.status = snapshot.get('status');
      notifyListeners();
    });

    notifyListeners();
  }
}