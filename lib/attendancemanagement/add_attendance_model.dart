import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAttendanceModel extends ChangeNotifier {
  final descriptionController = TextEditingController();

  String? username;
  String? title;
  DateTime? start;
  DateTime? end;
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

  Future addAttendance(String content, DateTimeRange dateTimeRange, TimeOfDay startTime, TimeOfDay endTime, bool mailsend) async {
    final user = FirebaseAuth.instance.currentUser;

    title = content;
    description = descriptionController.text;
    start = DateTime(
      dateTimeRange.start.year,
      dateTimeRange.start.month,
      dateTimeRange.start.day,
      startTime.hour,
      startTime.minute,
    );
    end = DateTime(
      dateTimeRange.end.year,
      dateTimeRange.end.month,
      dateTimeRange.end.day,
      endTime.hour,
      endTime.minute,
    );
    mailSend = mailsend;

    if (title == null || title == "") {
      throw 'タイトルが入力されていません';
    }

      final doc = FirebaseFirestore.instance.collection('attendances').doc();
      //firestoreに追加
      await doc.set ({
        'title': title,
        'user_name': username,
        'start': start,
        'end': end,
        'description': description,
        'mailSend': mailSend,
        'userId': user!.uid
      });

    notifyListeners();
  }
}