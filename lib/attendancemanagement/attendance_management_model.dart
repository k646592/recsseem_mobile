import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/attendance.dart';
import '../domain/user.dart';

class AttendanceListModel extends ChangeNotifier {
  List<Member> users = [];

  List<Attendance> attendances = [];
  Map<DateTime, List<dynamic>> attendancesList = {};  //key:date, value:attendance

  Map<String, List<dynamic>> userGroupList = {};  //key:group, value:user

  String? email;
  String? name;
  String? group;
  String? grade;
  String? status;

  void fetchAttendanceList() async {
    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('attendances').get();

    final List<Attendance> attendances = snap.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String username = data['user_name'];
      final String title = data['title'];
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      final String userId = data['userId'];
      return Attendance(id, username, title, start, end, description, mailSend, userId);
    }).toList();

    this.attendances = attendances;

    attendancesList = {};

    for (var event in attendances) {
      if (attendancesList[DateTime(event.start.year, event.start.month, event.start.day)] != null) {
        attendancesList[DateTime(event.start.year, event.start.month, event.start.day)]?.add(event);
      }
      else {
        attendancesList[DateTime(event.start.year, event.start.month, event.start.day)] = [event];
      }
    }

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

    userGroupList = {};

    for (var user in users) {
      if (userGroupList[user.group] != null) {
        userGroupList[user.group]?.add(user);
      }
      else {
        userGroupList[user.group] = [user];
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

  Future attendanceUpdate(String attendance) async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'status': attendance,
    });
  }

  Future delete(Attendance attendance) {
    final user = FirebaseAuth.instance.currentUser;
    if ( user!.uid != attendance.userId){
      throw 'イベント投稿者ではないため、削除できません。';
    }
    return FirebaseFirestore.instance.collection('attendances').doc(attendance.id).delete();
  }

}