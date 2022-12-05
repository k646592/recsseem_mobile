import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/domain/event.dart';

class AttendanceListModel extends ChangeNotifier {
  Map<DateTime, List<dynamic>> eventsList = {};  //key:date, value:title

  String? email;
  String? name;
  String? group;
  String? grade;

  void fetchAttendanceList() async {

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      this.name = snapshot.get('name');
      this.group = snapshot.get('group');
      this.grade = snapshot.get('grade');
      this.email = snapshot.get('email');
      notifyListeners();
    });

    notifyListeners();
  }

}