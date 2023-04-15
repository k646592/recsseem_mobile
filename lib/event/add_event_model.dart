import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEventModel extends ChangeNotifier {
  final descriptionController = TextEditingController();

  String? username;
  String? title;
  DateTime? start;
  DateTime? end;
  String? unit;
  String? description;
  bool? mailSend;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setUnit(String unit) {
    this.unit = unit;
    notifyListeners();
  }

  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      username = snapshot.get('name');
      notifyListeners();
    });
    notifyListeners();
  }

  Future addEvent(String title, String unit, DateTimeRange dateTimeRange, TimeOfDay startTime, TimeOfDay endTime, bool mailsend) async {
    final user = FirebaseAuth.instance.currentUser;

    this.title = title;
    this.unit = unit;
    this.description = descriptionController.text;
    this.start = DateTime(
        dateTimeRange.start.year,
        dateTimeRange.start.month,
        dateTimeRange.start.day,
        startTime.hour,
        startTime.minute,
    );
    this.end = DateTime(
        dateTimeRange.end.year,
        dateTimeRange.end.month,
        dateTimeRange.end.day,
        endTime.hour,
        endTime.minute,
    );
    this.mailSend = mailsend;

    if (title == null || title == "") {
      throw 'タイトルが入力されていません';
    }

    if (unit == null || unit == "") {
      throw '参加単位が入力されていません';
    }

    if(title.length > 30) {
      throw 'タイトルの文字数が多いです';
    }

    final Color color = Colors.red;

    final doc = FirebaseFirestore.instance.collection('events').doc();
    //firestoreに追加
    await doc.set ({
      'title': title,
      'user_name': username,
      'start': start,
      'end': end,
      'unit': unit,
      'description': description,
      'mailSend': mailSend,
      'userId': user!.uid,
      'color': color.value,
    });
    notifyListeners();
  }
}